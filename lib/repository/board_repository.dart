import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/community_post.dart';
import '../models/community_comment.dart';

/// Firestore 게시판 CRUD (게시글 + 댓글)
/// posts/{postId}/comments/{commentId} 구조
/// 통합 게시판: category(news/board) + religion(all 또는 종교 id) 필터
class BoardRepository {
  BoardRepository._();

  static final _store = FirebaseFirestore.instance;
  static const _posts = 'posts';
  static const _comments = 'comments';

  static const int _defaultLimit = 30;

  // ── 게시글 스트림 ──────────────────────────────────────────────────────

  /// 전체 게시글 (최신순, 실시간) — 레거시 호환용
  static Stream<List<CommunityPost>> postsStream() {
    return postsStreamFiltered(
      religion: null,
      category: null,
      limit: _defaultLimit,
    );
  }

  /// 필터 스트림: religion null이면 전체, category null이면 전체. limit·orderBy 적용.
  static Stream<List<CommunityPost>> postsStreamFiltered({
    String? religion,
    String? category,
    int limit = _defaultLimit,
  }) {
    var col = _store
        .collection(_posts)
        .withConverter<CommunityPost>(
          fromFirestore: (snap, _) => CommunityPost.fromFirestore(snap),
          toFirestore: (post, _) => post.toFirestore(),
        );

    // 기본(최적) 쿼리: where + orderBy(createdAt desc) + limit
    // 인덱스가 없으면 failed-precondition이 발생할 수 있어, 그 경우 임시 폴백 스트림으로 전환한다.
    Stream<List<CommunityPost>> buildIndexedStream() {
      Query<CommunityPost> q = col;
      if (category != null && category.isNotEmpty) {
        q = q.where('category', isEqualTo: category);
      }
      if (religion != null && religion.isNotEmpty) {
        q = q.where('religion', isEqualTo: religion);
      }
      q = q.orderBy('createdAt', descending: true).limit(limit);

      return q.snapshots().map((snap) => snap.docs.map((d) => d.data()).toList());
    }

    // 폴백 쿼리: 인덱스 없이 동작하도록 createdAt만 정렬 후 클라에서 필터링
    // (인덱스가 생성되면 자동으로 최적 쿼리를 사용하도록 위 스트림이 정상 동작)
    Stream<List<CommunityPost>> buildFallbackStream() {
      return col
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snap) {
        final all = snap.docs.map((d) => d.data()).toList();
        return all.where((p) {
          final okCategory =
              category == null || category.isEmpty || p.category == category;
          final okReligion =
              religion == null ||
              religion.isEmpty ||
              p.religion == religion;
          return okCategory && okReligion;
        }).toList();
      });
    }

    return Stream<List<CommunityPost>>.multi((controller) {
      late final StreamSubscription<List<CommunityPost>> sub;

      void listenFallback() {
        final fb = buildFallbackStream().listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
          cancelOnError: false,
        );
        controller.onCancel = () => fb.cancel();
      }

      sub = buildIndexedStream().listen(
        controller.add,
        onError: (e, st) async {
          if (e is FirebaseException && e.code == 'failed-precondition') {
            await sub.cancel();
            listenFallback();
            return;
          }
          controller.addError(e, st);
        },
        onDone: controller.close,
        cancelOnError: false,
      );

      controller.onCancel = () => sub.cancel();
    });
  }

  /// 단일 게시글 스트림
  static Stream<CommunityPost?> postStream(String postId) {
    return _store
        .collection(_posts)
        .doc(postId)
        .withConverter<CommunityPost>(
          fromFirestore: (snap, _) => CommunityPost.fromFirestore(snap),
          toFirestore: (post, _) => post.toFirestore(),
        )
        .snapshots()
        .map((snap) => snap.exists ? snap.data() : null);
  }

  // ── 게시글 CRUD ─────────────────────────────────────────────────────────

  /// 게시글 작성 (category·religion 기본값: board, all)
  static Future<String> createPost({
    required String title,
    required String body,
    required String authorUid,
    required String authorDisplayName,
    required bool isAnonymous,
    String category = PostCategory.board,
    String religion = 'all',
  }) async {
    final ref = await _store.collection(_posts).add({
      'title': title.trim(),
      'body': body.trim(),
      'authorUid': authorUid,
      'authorDisplayName': authorDisplayName,
      'isAnonymous': isAnonymous,
      'createdAt': FieldValue.serverTimestamp(),
      'commentCount': 0,
      'category': category,
      'religion': religion,
      'likeCount': 0,
    });
    return ref.id;
  }

  /// 게시글 삭제 (서브컬렉션 댓글도 일괄 삭제)
  static Future<void> deletePost(String postId) async {
    final commentSnap = await _store
        .collection(_posts)
        .doc(postId)
        .collection(_comments)
        .get();
    final batch = _store.batch();
    for (final doc in commentSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_store.collection(_posts).doc(postId));
    await batch.commit();
  }

  // ── 댓글 스트림 ─────────────────────────────────────────────────────────

  /// 특정 게시글 댓글 (등록순, 실시간)
  static Stream<List<CommunityComment>> commentsStream(String postId) {
    return _store
        .collection(_posts)
        .doc(postId)
        .collection(_comments)
        .withConverter<CommunityComment>(
          fromFirestore: (snap, _) => CommunityComment.fromFirestore(snap),
          toFirestore: (_, __) => {},
        )
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  // ── 댓글 CRUD ───────────────────────────────────────────────────────────

  /// 댓글 작성 (댓글 수 원자적 증가 포함)
  static Future<void> createComment({
    required String postId,
    required String body,
    required String authorUid,
    required String authorDisplayName,
    required bool isAnonymous,
  }) async {
    final batch = _store.batch();
    final commentRef = _store
        .collection(_posts)
        .doc(postId)
        .collection(_comments)
        .doc();
    batch.set(commentRef, {
      'body': body.trim(),
      'authorUid': authorUid,
      'authorDisplayName': authorDisplayName,
      'isAnonymous': isAnonymous,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(_store.collection(_posts).doc(postId), {
      'commentCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  /// 댓글 삭제 (댓글 수 원자적 감소 포함)
  static Future<void> deleteComment(String postId, String commentId) async {
    final batch = _store.batch();
    batch.delete(_store
        .collection(_posts)
        .doc(postId)
        .collection(_comments)
        .doc(commentId));
    batch.update(_store.collection(_posts).doc(postId), {
      'commentCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }
}

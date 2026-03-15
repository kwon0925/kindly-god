import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';

/// Firestore 게시판 CRUD (게시글 + 댓글)
/// posts/{postId}/comments/{commentId} 구조
class BoardRepository {
  BoardRepository._();

  static final _store = FirebaseFirestore.instance;
  static const _posts = 'posts';
  static const _comments = 'comments';

  // ── 게시글 스트림 ──────────────────────────────────────────────────────

  /// 전체 게시글 (최신순, 실시간)
  static Stream<List<CommunityPost>> postsStream() {
    return _store
        .collection(_posts)
        .withConverter<CommunityPost>(
          fromFirestore: (snap, _) => CommunityPost.fromFirestore(snap),
          toFirestore: (post, _) => post.toFirestore(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
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

  /// 게시글 작성
  static Future<String> createPost({
    required String title,
    required String body,
    required String authorUid,
    required String authorDisplayName,
    required bool isAnonymous,
  }) async {
    final ref = await _store.collection(_posts).add({
      'title': title.trim(),
      'body': body.trim(),
      'authorUid': authorUid,
      'authorDisplayName': authorDisplayName,
      'isAnonymous': isAnonymous,
      'createdAt': FieldValue.serverTimestamp(),
      'commentCount': 0,
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

import 'package:cloud_firestore/cloud_firestore.dart';

/// 게시글 카테고리: news=활동소식, board=자유게시판
class PostCategory {
  static const String news = 'news';
  static const String board = 'board';
}

/// Firebase 게시판 게시글 모델 (활동소식·자유게시판 통합, category/religion 필터)
class CommunityPost {
  final String id;
  final String title;
  final String body;
  final String authorUid;
  final String authorDisplayName;
  final bool isAnonymous;
  final DateTime createdAt;
  final int commentCount;
  /// 'news' | 'board'
  final String category;
  /// 'all' 또는 종교 id (christianity, buddhism 등)
  final String religion;
  final int likeCount;

  const CommunityPost({
    required this.id,
    required this.title,
    required this.body,
    required this.authorUid,
    required this.authorDisplayName,
    required this.isAnonymous,
    required this.createdAt,
    this.commentCount = 0,
    this.category = PostCategory.board,
    this.religion = 'all',
    this.likeCount = 0,
  });

  /// 익명 여부에 따라 표시할 이름
  String get displayAuthor => isAnonymous ? '익명' : authorDisplayName;

  factory CommunityPost.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return CommunityPost(
      id: doc.id,
      title: d['title'] as String? ?? '',
      body: d['body'] as String? ?? '',
      authorUid: d['authorUid'] as String? ?? '',
      authorDisplayName: d['authorDisplayName'] as String? ?? '사용자',
      isAnonymous: d['isAnonymous'] as bool? ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      commentCount: (d['commentCount'] as num?)?.toInt() ?? 0,
      category: d['category'] as String? ?? PostCategory.board,
      religion: d['religion'] as String? ?? 'all',
      likeCount: (d['likeCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'body': body,
    'authorUid': authorUid,
    'authorDisplayName': authorDisplayName,
    'isAnonymous': isAnonymous,
    'createdAt': FieldValue.serverTimestamp(),
    'commentCount': commentCount,
    'category': category,
    'religion': religion,
    'likeCount': likeCount,
  };
}

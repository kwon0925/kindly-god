import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase 게시판 게시글 모델 (활동 소식과 별개로 관리)
class CommunityPost {
  final String id;
  final String title;
  final String body;
  final String authorUid;
  final String authorDisplayName;
  final bool isAnonymous;
  final DateTime createdAt;
  final int commentCount;

  const CommunityPost({
    required this.id,
    required this.title,
    required this.body,
    required this.authorUid,
    required this.authorDisplayName,
    required this.isAnonymous,
    required this.createdAt,
    this.commentCount = 0,
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
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'body': body,
    'authorUid': authorUid,
    'authorDisplayName': authorDisplayName,
    'isAnonymous': isAnonymous,
    'createdAt': FieldValue.serverTimestamp(),
    'commentCount': 0,
  };
}

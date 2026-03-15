import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase 게시판 댓글 모델
class CommunityComment {
  final String id;
  final String body;
  final String authorUid;
  final String authorDisplayName;
  final bool isAnonymous;
  final DateTime createdAt;

  const CommunityComment({
    required this.id,
    required this.body,
    required this.authorUid,
    required this.authorDisplayName,
    required this.isAnonymous,
    required this.createdAt,
  });

  /// 익명 여부에 따라 표시할 이름
  String get displayAuthor => isAnonymous ? '익명' : authorDisplayName;

  factory CommunityComment.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return CommunityComment(
      id: doc.id,
      body: d['body'] as String? ?? '',
      authorUid: d['authorUid'] as String? ?? '',
      authorDisplayName: d['authorDisplayName'] as String? ?? '사용자',
      isAnonymous: d['isAnonymous'] as bool? ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';
import '../repository/board_repository.dart';

/// 전체 게시글 실시간 스트림
final boardPostsProvider = StreamProvider<List<CommunityPost>>((ref) {
  return BoardRepository.postsStream();
});

/// 단일 게시글 실시간 스트림
final boardPostProvider =
    StreamProvider.family<CommunityPost?, String>((ref, postId) {
  return BoardRepository.postStream(postId);
});

/// 특정 게시글 댓글 실시간 스트림
final boardCommentsProvider =
    StreamProvider.family<List<CommunityComment>, String>((ref, postId) {
  return BoardRepository.commentsStream(postId);
});

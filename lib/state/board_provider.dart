import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/community_post.dart';
import '../models/community_comment.dart';
import '../models/post_list_filter.dart';
import '../repository/board_repository.dart';

/// 전체 게시글 실시간 스트림 (레거시)
final boardPostsProvider = StreamProvider<List<CommunityPost>>((ref) {
  return BoardRepository.postsStream();
});

/// 필터 적용 게시글 스트림 (religion, category, limit)
final filteredBoardPostsProvider =
    StreamProvider.family<List<CommunityPost>, PostListFilter>((ref, filter) {
  return BoardRepository.postsStreamFiltered(
    religion: filter.religion,
    category: filter.category,
    limit: filter.limit,
  );
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

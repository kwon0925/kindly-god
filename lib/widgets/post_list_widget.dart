import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/community_post.dart';
import '../models/post_list_filter.dart';
import '../state/board_provider.dart';

/// 통합 게시글 목록 위젯 (활동소식/자유게시판 공통)
/// [religion] null → 전체, [category] 'news' | 'board'
/// [limit] 미지정 시 30. [scrollable] true면 목록이 단독 스크롤(전체화면용)
class PostListWidget extends ConsumerWidget {
  const PostListWidget({
    super.key,
    this.religion,
    this.category,
    this.limit = 30,
    this.listStyle = PostListStyle.vertical,
    this.scrollable = false,
    this.emptyMessage,
  });

  final String? religion;
  final String? category;
  final int limit;
  final PostListStyle listStyle;
  final bool scrollable;
  final String? emptyMessage;

  PostListFilter get _filter => PostListFilter(
        religion: religion,
        category: category ?? PostCategory.board,
        limit: limit,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(filteredBoardPostsProvider(_filter));

    return async.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '${AppLocalizations.of(context).cannotLoadList}\n$e',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
      data: (posts) {
        if (posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                emptyMessage ?? AppLocalizations.of(context).noPostsYet,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
          );
        }
        switch (listStyle) {
          case PostListStyle.vertical:
            return _VerticalList(posts: posts, scrollable: scrollable);
          case PostListStyle.horizontal:
            return _HorizontalList(posts: posts);
        }
      },
    );
  }
}

enum PostListStyle { vertical, horizontal }

class _VerticalList extends StatelessWidget {
  const _VerticalList({required this.posts, this.scrollable = false});

  final List<CommunityPost> posts;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: !scrollable,
      physics: scrollable
          ? null
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final post = posts[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          title: Text(
            post.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Text(
                  post.displayAuthor,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(post.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          trailing: post.commentCount > 0
              ? Chip(
                  label: Text(
                    AppLocalizations.of(context).commentCount(post.commentCount),
                    style: const TextStyle(fontSize: 11),
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                )
              : null,
          onTap: () =>
              context.push(AppRoutes.boardGeneralDetailPath(post.id)),
        );
      },
    );
  }

  static String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
  }
}

class _HorizontalList extends StatelessWidget {
  const _HorizontalList({required this.posts});

  final List<CommunityPost> posts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final post = posts[i];
          return SizedBox(
            width: 280,
            child: Card(
              child: InkWell(
                onTap: () =>
                    context.push(AppRoutes.boardGeneralDetailPath(post.id)),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        post.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.body,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

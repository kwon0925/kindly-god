import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../state/board_provider.dart';

/// 메인 화면 하단 게시판 최신글 섹션 (최근 5개, Firestore 실시간)
class HomeBoardSection extends ConsumerWidget {
  const HomeBoardSection({super.key});

  static const int _displayCount = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(boardPostsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('게시판', style: Theme.of(context).textTheme.titleMedium),
            TextButton(
              onPressed: () => context.push(AppRoutes.boardGeneral),
              child: const Text('전체보기'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        postsAsync.when(
          loading: () => const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (posts) {
            final latest = posts.take(_displayCount).toList();
            if (latest.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '아직 게시글이 없습니다.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade500),
                ),
              );
            }
            return Column(
              children: latest
                  .map((post) => InkWell(
                        onTap: () => context
                            .push(AppRoutes.boardGeneralDetailPath(post.id)),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 18,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  post.title,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (post.commentCount > 0)
                                Text(
                                  '[${post.commentCount}]',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, size: 20),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../data/dummy_board_general.dart';

/// 메인 화면 활동소식 아래 게시판 섹션 (최근 5개 제목 + 전체보기)
class HomeBoardSection extends StatelessWidget {
  const HomeBoardSection({super.key});

  static const int _displayCount = 5;

  @override
  Widget build(BuildContext context) {
    final latest = getLatestBoardGeneralPosts(_displayCount);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '게시판',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.boardGeneral),
              child: const Text('전체보기'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...latest.map((post) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => context.push(AppRoutes.boardGeneralDetailPath(post.id)),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Icon(Icons.article_outlined, size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      post.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }
}

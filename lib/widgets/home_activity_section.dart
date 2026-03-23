import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/community_post.dart';
import 'post_list_widget.dart';

/// 메인 화면 활동 소식 섹션 (Firestore 통합, category: news)
class HomeActivitySection extends StatelessWidget {
  const HomeActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '활동 소식',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.board),
              child: const Text('전체보기'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const PostListWidget(
          religion: null,
          category: PostCategory.news,
          limit: 5,
          listStyle: PostListStyle.horizontal,
          emptyMessage: '아직 활동 소식이 없습니다.',
        ),
      ],
    );
  }
}

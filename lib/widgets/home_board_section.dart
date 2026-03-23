import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/community_post.dart';
import 'post_list_widget.dart';

/// 메인 화면 게시판 최신글 섹션 (Firestore 통합, category: board, 최근 5개)
class HomeBoardSection extends StatelessWidget {
  const HomeBoardSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        const PostListWidget(
          religion: null,
          category: PostCategory.board,
          limit: 5,
          listStyle: PostListStyle.vertical,
          emptyMessage: '아직 게시글이 없습니다.',
        ),
      ],
    );
  }
}

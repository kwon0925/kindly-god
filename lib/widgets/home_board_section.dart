import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
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
            Text(AppLocalizations.of(context).boardTitle, style: Theme.of(context).textTheme.titleMedium),
            TextButton(
              onPressed: () => context.push(AppRoutes.boardGeneral),
              child: Text(AppLocalizations.of(context).seeAll),
            ),
          ],
        ),
        const SizedBox(height: 8),
        PostListWidget(
          religion: null,
          category: PostCategory.board,
          limit: 5,
          listStyle: PostListStyle.vertical,
          emptyMessage: AppLocalizations.of(context).noPostsYet,
        ),
      ],
    );
  }
}

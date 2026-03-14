import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../data/dummy_board_general.dart';
import '../models/board_post.dart';

/// 게시판 전체 목록 (10개). 활동 소식 화면과 별도 관리.
class BoardGeneralScreen extends StatelessWidget {
  const BoardGeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = List<BoardPost>.from(dummyBoardGeneralPosts)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시판'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, i) {
          final post = posts[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(post.title),
              subtitle: post.summary.isNotEmpty
                  ? Text(
                      post.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                    )
                  : null,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.boardGeneralDetailPath(post.id)),
            ),
          );
        },
      ),
    );
  }
}

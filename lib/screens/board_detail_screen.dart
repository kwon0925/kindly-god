import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_board.dart';
import '../models/board_post.dart';
import '../widgets/activity_detail_hero.dart';

class BoardDetailScreen extends StatelessWidget {
  final String postId;

  const BoardDetailScreen({super.key, required this.postId});

  BoardPost get _post {
    final list = dummyBoardPosts;
    return list.firstWhere((p) => p.id == postId, orElse: () => list.first);
  }

  @override
  Widget build(BuildContext context) {
    final post = _post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('활동 상세'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActivityDetailHero(imageUrl: post.imageUrl),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    post.summary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    post.body,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '기여 포인트가 위 활동에 사용되었음을 공개합니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

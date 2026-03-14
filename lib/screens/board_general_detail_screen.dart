import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_board_general.dart';
import '../models/board_post.dart';

/// 게시판 글 상세. 게시판용 데이터만 사용.
class BoardGeneralDetailScreen extends StatelessWidget {
  final String postId;

  const BoardGeneralDetailScreen({super.key, required this.postId});

  BoardPost get _post {
    return dummyBoardGeneralPosts.firstWhere(
      (p) => p.id == postId,
      orElse: () => dummyBoardGeneralPosts.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = _post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                _formatDate(post.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
              if (post.summary.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  post.summary,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade700),
                ),
              ],
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
  }
}

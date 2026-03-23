import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/board_write_form.dart';

/// 게시글 작성 화면 — 레이아웃 담당
class BoardWriteScreen extends ConsumerWidget {
  const BoardWriteScreen({
    super.key,
    this.initialReligion,
    this.initialCategory,
  });

  final String? initialReligion;
  final String? initialCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글쓰기'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BoardWriteForm(
        initialReligion: initialReligion,
        initialCategory: initialCategory,
      ),
    );
  }
}

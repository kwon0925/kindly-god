import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../repository/board_repository.dart';
import '../repository/user_profile_repository.dart';
import '../services/auth_service.dart';
import '../widgets/board_write_form.dart';

/// 게시글 작성 화면 — 라우트 진입점, 레이아웃만 담당
class BoardWriteScreen extends ConsumerWidget {
  const BoardWriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 작성'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: const BoardWriteForm(),
    );
  }
}

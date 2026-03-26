import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/admin/admin_role.dart';
import '../config/routes.dart';
import '../models/community_post.dart';
import '../services/auth_service.dart';
import '../state/user_profile_provider.dart';
import '../widgets/post_list_widget.dart';

/// 게시판 전체 목록 (자유게시판만, Firestore 실시간)
class BoardGeneralScreen extends ConsumerWidget {
  const BoardGeneralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).boardTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: profileAsync.when(
        loading: () => null,
        error: (_, __) => null,
        data: (profile) {
          final user = AuthService.currentUser;
          final isAdmin = AdminRole.isAdmin(profile?.role) || (user?.isAnonymous ?? false);
          if (isAdmin) {
            return FloatingActionButton.extended(
              onPressed: () => context.push(
                '${AppRoutes.boardWrite}?religion=all&category=${PostCategory.board}',
              ),
              icon: const Icon(Icons.edit),
              label: Text(AppLocalizations.of(context).writePost),
            );
          }
          final religionId = profile?.religionId;
          if (religionId == null || religionId.isEmpty) return null;
          return FloatingActionButton.extended(
            onPressed: () => context.push(
              '${AppRoutes.boardWrite}?religion=$religionId&category=${PostCategory.board}',
            ),
            icon: const Icon(Icons.edit),
            label: Text(AppLocalizations.of(context).writePost),
          );
        },
      ),
      body: PostListWidget(
        religion: null,
        category: PostCategory.board,
        scrollable: true,
        emptyMessage: AppLocalizations.of(context).noPostsWriteFirst,
      ),
    );
  }
}

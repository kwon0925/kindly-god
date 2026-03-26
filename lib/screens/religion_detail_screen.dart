import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/admin/admin_role.dart';
import '../config/routes.dart';
import '../models/community_post.dart';
import '../models/religion.dart';
import '../services/auth_service.dart';
import '../state/test_point_provider.dart';
import '../state/user_profile_provider.dart';
import '../widgets/post_list_widget.dart';

class ReligionDetailScreen extends ConsumerWidget {
  final String religionId;

  const ReligionDetailScreen({super.key, required this.religionId});

  Religion get _religion {
    return defaultReligions.firstWhere(
      (r) => r.id == religionId,
      orElse: () => defaultReligions.first,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = _religion;
    final lang = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    final points = ref.watch(testPointProvider).state.getReligionPoints(r.id);
    final profileAsync = ref.watch(currentUserProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(r.displayName(lang)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
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
                '${AppRoutes.boardWrite}?religion=$religionId',
              ),
              icon: const Icon(Icons.edit),
              label: Text(l10n.writePost),
            );
          }
          final userReligion = profile?.religionId;
          if (userReligion == null || userReligion.isEmpty) return null;
          if (userReligion != religionId) return null;
          return FloatingActionButton.extended(
            onPressed: () => context.push(
              '${AppRoutes.boardWrite}?religion=$religionId',
            ),
            icon: const Icon(Icons.edit),
            label: Text(l10n.writePost),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      Religion.symbol(r.id),
                      style: TextStyle(fontSize: 64, height: 1.1, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(r.displayName(lang), style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('$points P', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.support),
                  icon: const Icon(Icons.volunteer_activism),
                  label: Text(l10n.supportThisReligion),
                ),
              ),
              const SizedBox(height: 28),
              Text(l10n.activityNewsTitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              PostListWidget(
                religion: religionId,
                category: PostCategory.news,
                limit: 10,
                scrollable: false,
                emptyMessage: l10n.noReligionActivity,
              ),
              const SizedBox(height: 20),
              Text(l10n.boardTitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              PostListWidget(
                religion: religionId,
                category: PostCategory.board,
                limit: 10,
                scrollable: false,
                emptyMessage: l10n.noReligionBoardPosts,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

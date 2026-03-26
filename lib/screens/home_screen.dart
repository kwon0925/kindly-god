import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../config/app_brand.dart';
import '../config/routes.dart';
import '../services/auth_service.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/home_ranking_section.dart';
import '../widgets/home_heaven_section.dart';
import '../widgets/home_activity_section.dart';
import '../widgets/home_board_section.dart';
import '../widgets/main_popup_overlay.dart';
import '../widgets/account_dialog.dart';
import '../widgets/login_only_dialog.dart';
import '../widgets/notification_permission_banner.dart';
import '../widgets/pwa_install_banner.dart';
import '../widgets/version_badge.dart';
import '../state/fcm_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void _showTranslateDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.translate, color: Colors.teal),
          const SizedBox(width: 8),
          Text(l10n.pageTranslateTitle),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          l10n.pageTranslateBody,
          style: TextStyle(height: 1.4),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(l10n.confirm),
        ),
      ],
    ),
  );
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _notificationIntroShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_notificationIntroShown) return;
    _notificationIntroShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNotificationIntroIfNeeded());
  }

  Future<void> _showNotificationIntroIfNeeded() async {
    final permission = ref.read(notificationPermissionProvider);
    if (permission == AuthorizationStatus.authorized ||
        permission == AuthorizationStatus.provisional) {
      return;
    }

    if (!mounted) return;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('알림 받기'),
        content: const Text('종교 순위 변동과 일일 요약 알림을 받으시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('나중에'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('허용하기'),
          ),
        ],
      ),
    );

    if (accepted == true) {
      final request = ref.read(requestNotificationPermissionProvider);
      await request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MainPopupOverlay(
      child: Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VersionBadge(),
            SizedBox(width: 8),
            Text(kAppDisplayName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.article),
            onPressed: () => context.push(AppRoutes.terms),
          ),
          IconButton(
            icon: const Icon(Icons.translate),
            tooltip: AppLocalizations.of(context).translateGuideTooltip,
            onPressed: () => _showTranslateDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              if (AuthService.currentUser == null) {
                LoginOnlyDialog.show(context);
              } else {
                AccountDialog.show(context);
              }
            },
          ),
        ],
      ),
      body: ResponsivePadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 알림 권한 유도 배너 (첫 방문 + 미결정 상태일 때만 자동 표시)
              const NotificationPermissionBanner(),
              const SizedBox(height: 16),
              const HomeRankingSection(),
              const SizedBox(height: 24),
              const HomeHeavenSection(),
              const SizedBox(height: 24),
              const HomeActivitySection(),
              const SizedBox(height: 24),
              const HomeBoardSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PwaInstallBanner(),
          BottomNavigationBar(
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.homeTab),
              BottomNavigationBarItem(icon: const Icon(Icons.volunteer_activism), label: l10n.supportTab),
              BottomNavigationBarItem(icon: const Icon(Icons.article_outlined), label: l10n.activityNewsTab),
            ],
            onTap: (i) {
              if (i == 1) context.push(AppRoutes.support);
              if (i == 2) context.push(AppRoutes.board);
            },
          ),
        ],
      ),
    ),
    );
  }
}

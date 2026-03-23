import 'package:flutter/material.dart';
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
import '../widgets/version_badge.dart';

void _showTranslateDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.translate, color: Colors.teal),
          SizedBox(width: 8),
          Text('페이지 번역'),
        ],
      ),
      content: const SingleChildScrollView(
        child: Text(
          '이 페이지는 한국어로 되어 있습니다.\n\n'
          '번역하려면:\n'
          '• Chrome/Edge: 주소창 오른쪽의 번역 아이콘을 누르거나,\n'
          '• 페이지에서 우클릭 후 "Translate to..." 를 선택하세요.\n\n'
          'This page is in Korean. To translate: use the translate icon in the address bar, or right‑click → Translate to your language.',
          style: TextStyle(height: 1.4),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('확인'),
        ),
      ],
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            tooltip: '페이지 번역 안내',
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: '응원하기'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: '활동 소식'),
        ],
        onTap: (i) {
          if (i == 1) context.push(AppRoutes.support);
          if (i == 2) context.push(AppRoutes.board);
        },
      ),
    ),
    );
  }
}

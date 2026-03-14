import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/ranking_tabs.dart';
import '../widgets/home_religion_grid.dart';
import '../widgets/home_activity_section.dart';
import '../widgets/home_board_section.dart';
import '../widgets/main_popup_overlay.dart';
import '../widgets/account_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPopupOverlay(
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Kindly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.article),
            onPressed: () => context.push(AppRoutes.terms),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => AccountDialog.show(context),
          ),
        ],
      ),
      body: ResponsivePadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                '종교별 · 계정별 랭킹',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const RankingTabs(),
              const SizedBox(height: 24),
              Text(
                '종교별 응원 포인트',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              const HomeReligionGrid(),
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

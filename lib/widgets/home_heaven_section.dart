import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';

/// 메인 화면 - 천국 영토 구매 섹션
class HomeHeavenSection extends StatelessWidget {
  const HomeHeavenSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).heavenCertificateTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // 배경 그라디언트 (이미지 대체, 추후 실제 이미지로 교체)
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1a1a2e),
                      Color(0xFF16213e),
                      Color(0xFF0f3460),
                      Color(0xFF533483),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // 별빛 효과
                    Positioned.fill(
                      child: CustomPaint(painter: _StarPainter()),
                    ),
                    // 중앙 텍스트
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '✨',
                            style: TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Certificate of Heavenly Estate',
                            style: TextStyle(
                              color: Colors.amber.shade200,
                              fontSize: 13,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context).heavenSubtitle,
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 구매 버튼
              Positioned(
                bottom: 16,
                right: 16,
                child: FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.heavenPurchase),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.star, size: 18),
                  label: Text(
                    AppLocalizations.of(context).buyLand,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 별빛 배경 그림 (단순 점 효과)
class _StarPainter extends CustomPainter {
  static const _stars = [
    (0.1, 0.15), (0.25, 0.4), (0.4, 0.1), (0.6, 0.3),
    (0.75, 0.12), (0.85, 0.5), (0.5, 0.65), (0.15, 0.7),
    (0.9, 0.8),  (0.35, 0.85),(0.65, 0.75),(0.05, 0.45),
    (0.8, 0.25), (0.45, 0.5), (0.7, 0.55),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(180)
      ..style = PaintingStyle.fill;

    for (final (rx, ry) in _stars) {
      canvas.drawCircle(
        Offset(size.width * rx, size.height * ry),
        1.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter _) => false;
}

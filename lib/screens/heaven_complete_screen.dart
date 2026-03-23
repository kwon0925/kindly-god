import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/heaven_order.dart';
import '../data/heaven_options.dart';

/// 천국 영토 구매 완료 화면
class HeavenCompleteScreen extends StatelessWidget {
  final HeavenOrder order;

  const HeavenCompleteScreen({super.key, required this.order});

  String get _afterlifeName =>
      HeavenOptions.afterlifeName(order.religion);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // 완료 아이콘
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withAlpha(100),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 44),
              ),
              const SizedBox(height: 24),
              Text(
                '🎉 ${order.name}님의\n토지가 구매되었습니다!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '약 3~4주 뒤 해당 주소로\n$_afterlifeName 토지증명서가 도착할 것입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amber.shade200,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),

              // 구매 요약 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.withAlpha(80),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('📜 구매 내역'),
                    const SizedBox(height: 12),
                    _row('소유자', order.name),
                    _row('종교', _afterlifeName),
                    _row('세계관', order.baseWorld),
                    _row('입지', order.location),
                    _row('분위기', order.vibe),
                    _row('효과', order.visualEffect),
                    _row('특별 서비스', order.specialPerk),
                    const Divider(color: Colors.white24, height: 24),
                    _row('발송 국가', order.country),
                    _row('주소', order.address),
                    _row('연락처', order.contact),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 기부 안내 메시지
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.withAlpha(60),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade300.withAlpha(80)),
                ),
                child: Text(
                  '💛  이생에서 구매하신 토지 이용료는\n불우한 이웃을 위해 사용됩니다.\n당신의 선행은 천상에 영원히 기록될 것입니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.indigo.shade100,
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 홈으로 버튼
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.home),
                  label: const Text(
                    '홈으로',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: TextStyle(
          color: Colors.amber.shade300,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
}

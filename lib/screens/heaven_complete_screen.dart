import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../config/routes.dart';
import '../models/heaven_order.dart';
import '../data/heaven_options.dart';

/// 천국 영토 구매 완료 화면
class HeavenCompleteScreen extends StatelessWidget {
  final HeavenOrder order;

  const HeavenCompleteScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final afterlifeName = HeavenOptions.afterlifeName(order.religion, lang);
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
                '🎉 ${l10n.congratsOwner(order.name)}',
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
                l10n.heavenCertificateArrival(afterlifeName),
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
                    _sectionTitle('📜 ${l10n.purchaseDetails}'),
                    const SizedBox(height: 12),
                    _row(l10n.ownerLabel, order.name),
                    _row(l10n.religionType, afterlifeName),
                    _row(l10n.baseWorld, order.baseWorld),
                    _row(l10n.locationLabel, order.location),
                    _row(l10n.vibeLabel, order.vibe),
                    _row(l10n.visualLabel, order.visualEffect),
                    _row(l10n.specialPerksLabel, order.specialPerk),
                    const Divider(color: Colors.white24, height: 24),
                    _row(l10n.shippingCountry, order.country),
                    _row(l10n.addressLabel, order.address),
                    _row(l10n.contactLabel, order.contact),
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
                  '💛  ${l10n.heavenDonationNoticeLong}',
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
                  label: Text(
                    l10n.goHome,
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

import 'package:flutter/material.dart';
import '../models/country.dart';
import 'rank_medal_overlay.dart';

/// 국가별 포인트 카드. 그리드용. 1·2·3위일 때 상단에 순위+메달 오버레이.
class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback? onTap;
  final int? rank;

  const CountryCard({
    super.key,
    required this.country,
    this.onTap,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final flag = Country.flagAssetPath(country.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (flag != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        flag,
                        width: 88,
                        height: 56,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    country.displayName(lang),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${country.points} P',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            if (rank != null && rank! >= 1 && rank! <= 3)
              Positioned(
                top: 6,
                left: 6,
                right: 6,
                child: RankMedalOverlay(rank: rank!),
              ),
          ],
        ),
      ),
    );
  }
}

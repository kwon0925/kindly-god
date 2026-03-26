import 'package:flutter/material.dart';
import 'package:kindly_god/gen_l10n/app_localizations.dart';

/// 1·2·3위 순위 + 메달 뱃지. 카드/이미지 상단에 겹쳐 표시용.
class RankMedalOverlay extends StatelessWidget {
  final int rank;

  const RankMedalOverlay({super.key, required this.rank});

  static const medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final i = rank - 1;
    if (i < 0 || i > 2) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).rankLabel(rank),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(medals[i], style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

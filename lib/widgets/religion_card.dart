import 'package:flutter/material.dart';
import '../models/religion.dart';
import 'rank_medal_overlay.dart';

class ReligionCard extends StatelessWidget {
  final Religion religion;
  final VoidCallback? onTap;
  /// 1·2·3위일 때만 전달. 이미지 상단에 "N위" + 메달 아이콘 오버레이 표시.
  final int? rank;

  const ReligionCard({
    super.key,
    required this.religion,
    this.onTap,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final imgPath = Religion.imagePath(religion.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 이미지 (반투명)
            if (imgPath != null)
              Positioned.fill(
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.45),
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            // 어두운 그라디언트 오버레이 (텍스트 가독성)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
            ),
            // 1·2·3위 순위 + 메달 오버레이 (이미지 상단)
            if (rank != null && rank! >= 1 && rank! <= 3)
              Positioned(
                top: 6,
                left: 6,
                right: 6,
                child: RankMedalOverlay(rank: rank!),
              ),
            // 콘텐츠
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Religion.symbol(religion.id),
                    style: TextStyle(
                      fontSize: 36,
                      height: 1.1,
                      color: imgPath != null
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      shadows: imgPath != null
                          ? [const Shadow(blurRadius: 4, color: Colors.black54)]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    religion.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: imgPath != null ? Colors.white : null,
                      fontWeight: FontWeight.bold,
                      shadows: imgPath != null
                          ? [const Shadow(blurRadius: 3, color: Colors.black87)]
                          : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${religion.points} P',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: imgPath != null
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      shadows: imgPath != null
                          ? [const Shadow(blurRadius: 3, color: Colors.black87)]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

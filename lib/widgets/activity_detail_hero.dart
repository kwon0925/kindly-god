import 'package:flutter/material.dart';
import 'responsive_layout.dart';

/// 활동 상세 상단 이미지
/// - 모바일: 220 높이
/// - PC: 더 넓은 높이 + BoxFit.contain 으로 이미지가 잘리지 않도록 표시
class ActivityDetailHero extends StatelessWidget {
  final String imageUrl;

  const ActivityDetailHero({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final height = isDesktop ? 360.0 : 220.0;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.image, size: 80),
        ),
      ),
    );
  }
}

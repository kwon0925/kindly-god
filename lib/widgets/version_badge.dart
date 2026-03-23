import 'package:flutter/material.dart';
import '../config/app_version.dart';

class VersionBadge extends StatelessWidget {
  const VersionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      appVersionLabel,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.red,
        height: 1,
      ),
    );
  }
}


import 'dart:async';

import 'package:flutter/material.dart';

class DonationBlessingDialog extends StatefulWidget {
  final String imageAssetPath;

  const DonationBlessingDialog({super.key, required this.imageAssetPath});

  @override
  State<DonationBlessingDialog> createState() => _DonationBlessingDialogState();
}

class _DonationBlessingDialogState extends State<DonationBlessingDialog> {
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _autoCloseTimer = Timer(const Duration(seconds: 5), _closeIfPossible);
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _closeIfPossible() {
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                widget.imageAssetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: const Text(
                    '이미지를 불러오지 못했습니다.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: '닫기',
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _closeIfPossible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

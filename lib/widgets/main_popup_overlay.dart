import 'package:flutter/material.dart';

/// 메인 페이지 접속 시 main.png 팝업 (닫기 시 제거)
class MainPopupOverlay extends StatefulWidget {
  final Widget child;

  const MainPopupOverlay({super.key, required this.child});

  @override
  State<MainPopupOverlay> createState() => _MainPopupOverlayState();
}

class _MainPopupOverlayState extends State<MainPopupOverlay> {
  bool _showPopup = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_showPopup) return;
      _showMainDialog();
    });
  }

  void _showMainDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Image.asset(
                  'assets/images/main.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 64),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() => _showPopup = false);
                  },
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

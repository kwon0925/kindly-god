import 'package:flutter/material.dart';

/// 게시판 관련 버튼 스타일 — 배경과 구분되도록 눈에 띄는 색 사용
class BoardButtonStyle {
  BoardButtonStyle._();

  /// 게시하기 버튼용 (Teal) — 기본 primary와 구분
  static ButtonStyle get submit => FilledButton.styleFrom(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      );
}

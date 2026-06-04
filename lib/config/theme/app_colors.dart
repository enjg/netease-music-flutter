import 'package:flutter/material.dart';

/// 应用颜色常量 - 暗色主题
class AppColors {
  AppColors._();

  // 背景色
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceVariant = Color(0xFF1A1A1A);

  // 液态玻璃
  static const Color glass = Color(0x14FFFFFF);        // rgba(255,255,255,0.08)
  static const Color glassBorder = Color(0x1AFFFFFF);   // rgba(255,255,255,0.10)
  static const Color glassHighlight = Color(0x0FFFFFFF); // rgba(255,255,255,0.06)

  // 文字色
  static const Color textPrimary = Color(0xE8E8E8E8);    // #e8e8e8
  static const Color textSecondary = Color(0x73FFFFFF);   // rgba(255,255,255,0.45)
  static const Color textTertiary = Color(0x40FFFFFF);    // rgba(255,255,255,0.25)

  // 强调色
  static const Color accent = Color(0xFFEC4141);
  static const Color accentLight = Color(0x26EC4141);     // rgba(236,65,65,0.15)

  // 功能色
  static const Color success = Color(0xFF4ECDC4);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFEC4141);
  static const Color info = Color(0xFF74B9FF);

  // 混合色 (用于渐变)
  static const List<Color> bgGradient = [
    Color(0xFF0A0A0A),
    Color(0xFF141414),
    Color(0xFF0A0A0A),
  ];
}

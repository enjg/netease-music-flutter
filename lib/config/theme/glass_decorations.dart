import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

/// 液态玻璃装饰 - 苹果风格
class GlassDecorations {
  GlassDecorations._();

  /// 液态玻璃卡片装饰
  static BoxDecoration card({
    double radius = AppDimensions.radiusXl,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.glass,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: AppColors.glassBorder,
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 24,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// 液态玻璃背景模糊
  static Widget blur({
    required Widget child,
    double sigma = 40,
    double opacity = 0.65,
  }) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          color: Colors.black.withOpacity(opacity),
          child: child,
        ),
      ),
    );
  }

  /// 液态玻璃高光效果
  static Widget highlight({
    required Widget child,
    double radius = AppDimensions.radiusXl,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.glassHighlight,
            Colors.transparent,
          ],
          stops: const [0.0, 0.5],
        ),
      ),
      child: child,
    );
  }

  /// 完整的液态玻璃容器
  static Widget container({
    required Widget child,
    double radius = AppDimensions.radiusXl,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double blurSigma = 40,
    double bgOpacity = 0.65,
  }) {
    return Container(
      margin: margin,
      decoration: card(radius: radius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(bgOpacity),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 0.5,
              ),
            ),
            child: highlight(
              radius: radius,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

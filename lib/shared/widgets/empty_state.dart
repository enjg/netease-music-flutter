import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';

/// 空状态组件
class EmptyState extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const EmptyState({
    super.key,
    this.icon = '📭',
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.bodyLarge),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            ],
            if (buttonText != null && onButtonTap != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onButtonTap,
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

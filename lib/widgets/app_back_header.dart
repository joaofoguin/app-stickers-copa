import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackHeader extends StatelessWidget {
  final String label;

  const AppBackHeader({
    super.key,
    this.label = 'Voltar',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.chevron_left,
                color: AppColors.textPrimary,
                size: 28,
              ),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
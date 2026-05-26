import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/pais_utils.dart';

class ProgressoSelecaoStoryItem extends StatelessWidget {
  final String nome;
  final int total;
  final int tenho;

  const ProgressoSelecaoStoryItem({
    super.key,
    required this.nome,
    required this.total,
    required this.tenho,
  });

  double get progresso {
    if (total == 0) return 0;
    return tenho / total;
  }

  String get porcentagem {
    return '${(progresso * 100).toStringAsFixed(0)}%';
  }

  String get nomeReduzido {
    return nomeReduzidoPais(nome);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 66,
                height: 66,
                child: CircularProgressIndicator(
                  value: progresso,
                  strokeWidth: 4,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryBlue,
                  ),
                ),
              ),
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDEDED),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    porcentagem,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            nomeReduzido.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$tenho/$total',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
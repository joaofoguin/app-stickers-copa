import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/pais_utils.dart';

class SelecaoStoryItem extends StatelessWidget {
  final String nome;
  final int total;
  final int tenho;
  final bool selecionado;
  final VoidCallback onTap;

  const SelecaoStoryItem({
    super.key,
    required this.nome,
    required this.total,
    required this.tenho,
    required this.selecionado,
    required this.onTap,
  });

  double get progresso {
    if (total == 0) return 0;
    return tenho / total;
  }

  String get sigla {
    if (nome == 'Todas') return 'ALL';
    return nomeReduzidoPais(nome);
  }

  String? get bandeiraAsset {
    if (nome == 'Todas') return null;
    return bandeiraAssetPais(nome);
  }

  String get nomeExibicao {
    if (nome == 'Todas') return 'TODAS';
    return sigla.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final corProgresso = selecionado
        ? AppColors.successGreen
        : AppColors.primaryBlue;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 82,
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
                    valueColor: AlwaysStoppedAnimation<Color>(corProgresso),
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: selecionado
                        ? const Color(0xFFB9F6C3)
                        : const Color(0xFFEDEDED),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: bandeiraAsset != null
                        ? Image.asset(
                            bandeiraAsset!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              sigla,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              nomeExibicao,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$tenho/$total',
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
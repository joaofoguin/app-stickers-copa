import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../theme/app_colors.dart';
import '../utils/numero_album_utils.dart';

class FigurinhaGridTile extends StatelessWidget {
  final Figurinha figurinha;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const FigurinhaGridTile({
    super.key,
    required this.figurinha,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final preenchida = figurinha.tenho;
    final repetida = figurinha.repetidas > 0;

    final sigla = prefixoNumeroAlbum(figurinha.numeroAlbum);
    final numero = numeroVisualAlbum(figurinha.numeroAlbum);

    final Color backgroundColor = preenchida
        ? const Color(0xFFE4F6E7)
        : const Color(0xFFBDBDBD);

    final Color borderColor = repetida
        ? AppColors.primaryBlue
        : preenchida
            ? AppColors.successGreen
            : Colors.transparent;

    const Color textColor = Colors.black;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: preenchida || repetida ? 2.2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sigla,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      numero,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                )
              ),
            ),

            if (preenchida)
              Positioned(
                left: 5,
                bottom: 5,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: const BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),

            if (repetida)
              Positioned(
                right: -5,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'x${figurinha.repetidas}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
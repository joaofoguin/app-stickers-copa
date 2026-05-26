import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class ColecaoTabSelector extends StatelessWidget {
  final int indiceAtual;
  final ValueChanged<int> onChanged;

  const ColecaoTabSelector({
    super.key,
    required this.indiceAtual,
    required this.onChanged,
  });

  static const List<String> tabs = [
    'TODAS',
    'FALTANTES',
    'REPETIDAS',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.background,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selecionada = indiceAtual == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: selecionada
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                          Color(0xFF050505),
                          Color(0xFF18091F),
                          Color(0xFF2A0D31),
                          ],
                        )
                      : null,
                  border: Border(
                    bottom: BorderSide(
                      color: selecionada
                          ? const Color(0xFF5A1B68)
                          : const Color(0xFF1A1A1A),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: GoogleFonts.oswald(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
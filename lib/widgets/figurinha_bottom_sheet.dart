import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../theme/app_colors.dart';

class FigurinhaBottomSheet extends StatefulWidget {
  final Figurinha figurinha;
  final void Function(bool valor) onMarcar;
  final VoidCallback onAdicionarRepetida;
  final VoidCallback onRemoverRepetida;

  const FigurinhaBottomSheet({
    super.key,
    required this.figurinha,
    required this.onMarcar,
    required this.onAdicionarRepetida,
    required this.onRemoverRepetida,
  });

  @override
  State<FigurinhaBottomSheet> createState() => _FigurinhaBottomSheetState();
}

class _FigurinhaBottomSheetState extends State<FigurinhaBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final figurinha = widget.figurinha;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 28),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  figurinha.numeroAlbum,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  figurinha.nome,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.surfaceLight,
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Repetidas',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: figurinha.repetidas == 0
                          ? null
                          : () {
                              widget.onRemoverRepetida();
                              setState(() {});
                            },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceLight,
                        disabledBackgroundColor: AppColors.surfaceMedium,
                      ),
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${figurinha.repetidas}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        widget.onAdicionarRepetida();
                        setState(() {});
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.successGreen,
                      ),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    widget.onMarcar(!figurinha.tenho);
                    setState(() {});
                  },
                  icon: Icon(
                    figurinha.tenho
                        ? Icons.delete_outline
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    figurinha.tenho
                        ? 'Remover preenchimento'
                        : 'Marcar como preenchida',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(
                      color: AppColors.surfaceLight,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
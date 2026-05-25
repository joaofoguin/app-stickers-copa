import 'package:flutter/material.dart';

import '../models/figurinha.dart';

class FigurinhaBottomSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, modalSetState) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              Text(
                figurinha.numeroAlbum,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                figurinha.nome,
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                figurinha.pais,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Repetidas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: figurinha.repetidas == 0
                          ? null
                          : () {
                              onRemoverRepetida();
                              modalSetState(() {});
                            },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${figurinha.repetidas}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onAdicionarRepetida();
                        modalSetState(() {});
                      },
                      icon: const Icon(Icons.add_circle),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    onMarcar(!figurinha.tenho);
                    modalSetState(() {});
                  },
                  icon: Icon(
                    figurinha.tenho
                        ? Icons.close
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    figurinha.tenho
                        ? 'Remover da coleção'
                        : 'Marcar como tenho',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
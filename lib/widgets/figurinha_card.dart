import 'package:flutter/material.dart';

import '../../../models/figurinha.dart';

class FigurinhaCard extends StatelessWidget {
  final Figurinha figurinha;
  final void Function(bool valor) onMarcar;
  final VoidCallback onAdicionarRepetida;
  final VoidCallback onRemoverRepetida;

  const FigurinhaCard({
    super.key,
    required this.figurinha,
    required this.onMarcar,
    required this.onAdicionarRepetida,
    required this.onRemoverRepetida,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            figurinha.numeroAlbum.length >= 3
                ? figurinha.numeroAlbum.substring(0, 3)
                : figurinha.numeroAlbum,
          ),
        ),
        title: Text('${figurinha.numeroAlbum} - ${figurinha.nome}'),
        subtitle: Text(
          '${figurinha.pais} | Repetidas: ${figurinha.repetidas}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onRemoverRepetida,
              icon: const Icon(Icons.remove),
            ),
            IconButton(
              onPressed: onAdicionarRepetida,
              icon: const Icon(Icons.add),
            ),
            Checkbox(
              value: figurinha.tenho,
              onChanged: (valor) {
                onMarcar(valor ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
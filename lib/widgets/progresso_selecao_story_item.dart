import 'package:flutter/material.dart';
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
      width: 82,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: progresso,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey.shade300,
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                ),
                child: Center(
                  child: Text(
                    porcentagem,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            nomeReduzido,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$tenho/$total',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
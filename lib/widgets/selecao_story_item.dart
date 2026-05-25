import 'package:flutter/material.dart';

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

    final limpo = nome.trim();

    if (limpo.length <= 3) {
      return limpo.toUpperCase();
    }

    return limpo.substring(0, 3).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cor = selecionado ? Colors.green : Colors.grey;

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
                  width: 62,
                  height: 62,
                  child: CircularProgressIndicator(
                    value: progresso,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: selecionado
                        ? Colors.green.shade100
                        : Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cor,
                      width: selecionado ? 3 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      sigla,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selecionado
                            ? Colors.green.shade900
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
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
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ConfiguracoesPage extends StatelessWidget {
  final Future<void> Function() onAtualizarCatalogo;
  final Future<void> Function() onLimparColecao;
  final int totalFigurinhas;

  const ConfiguracoesPage({
    super.key,
    required this.onAtualizarCatalogo,
    required this.onLimparColecao,
    required this.totalFigurinhas,
  });

  Future<void> atualizarCatalogo(BuildContext context) async {
    await onAtualizarCatalogo();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CATÁLOGO ATUALIZADO'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> confirmarLimpeza(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'LIMPAR COLEÇÃO',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const Text(
            'DESEJA REMOVER TODAS AS MARCAÇÕES E REPETIDAS SALVAS?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('LIMPAR'),
            ),
          ],
        );
      },
    );

    if (confirmou == true) {
      await onLimparColecao();
    }
  }

  void mostrarMensagemEmBreve(BuildContext context, String titulo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$titulo EM BREVE'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 140),
      children: [
        const Text(
          'CONFIGURAÇÕES',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),

        const SizedBox(height: 22),

        ConfiguracaoItem(
          icone: Icons.refresh,
          titulo: 'ATUALIZAR CATÁLOGO',
          subtitulo: 'BUSCA POR FIGURINHAS NOVAS',
          onTap: () => atualizarCatalogo(context),
        ),

        const SizedBox(height: 10),

        ConfiguracaoItem(
          icone: Icons.collections_bookmark_outlined,
          titulo: 'TOTAL CATÁLOGO',
          subtitulo: '$totalFigurinhas FIGURINHAS CARREGADAS',
          onTap: null,
        ),

        const SizedBox(height: 10),

        ConfiguracaoItem(
          icone: Icons.info_outline,
          titulo: 'SOBRE O APP',
          subtitulo: 'ÁLBUM DE SELEÇÕES',
          onTap: () => mostrarMensagemEmBreve(context, 'SOBRE O APP'),
        ),

        const SizedBox(height: 10),

        const ConfiguracaoItem(
          icone: Icons.menu_book_outlined,
          titulo: 'VERSÃO',
          subtitulo: '1.0.0',
          onTap: null,
        ),

        const SizedBox(height: 10),

        ConfiguracaoItem(
          icone: Icons.delete_outline,
          titulo: 'LIMPAR COLEÇÃO',
          subtitulo: 'REMOVE TODAS AS MARCAÇÕES E REPETIDAS SALVAS',
          perigo: true,
          onTap: () => confirmarLimpeza(context),
        ),

        const SizedBox(height: 10),

        ConfiguracaoItem(
          icone: Icons.help_outline,
          titulo: 'SAC',
          subtitulo: 'FALE CONOSCO',
          onTap: () => mostrarMensagemEmBreve(context, 'SAC'),
        ),

        const SizedBox(height: 10),

        ConfiguracaoItem(
          icone: Icons.card_giftcard,
          titulo: 'AJUDE O DESENVOLVEDOR',
          subtitulo: 'PRESENTEAR COM UM PACOTE DE FIGURINHAS',
          onTap: () => mostrarMensagemEmBreve(
            context,
            'AJUDE O DESENVOLVEDOR',
          ),
        ),
      ],
    );
  }
}

class ConfiguracaoItem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback? onTap;
  final bool perigo;

  const ConfiguracaoItem({
    super.key,
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    this.perigo = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = perigo ? Colors.redAccent : AppColors.textPrimary;
    final Color titleColor = perigo ? Colors.redAccent : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            child: Row(
              children: [
                Icon(
                  icone,
                  color: iconColor,
                  size: 28,
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        subtitulo.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                if (onTap != null) ...[
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
# Álbum da Copa

Aplicativo Flutter para gerenciamento de coleção de figurinhas de seleções, com catálogo carregado por API, marcação de figurinhas possuídas, controle de repetidas, estatísticas da coleção e funcionalidade de scan de páginas do álbum.

O objetivo do app é facilitar o acompanhamento da coleção de forma visual, rápida e prática, permitindo que o usuário registre manualmente ou por scan quais figurinhas já possui.

---

## Funcionalidades

### Coleção

- Listagem de figurinhas agrupadas por seleção.
- Organização das seleções conforme a ordem do álbum.
- Visualização em grade de figurinhas.
- Marcação rápida de figurinha como possuída ao tocar no card.
- Ao tocar novamente em uma figurinha já marcada, abre uma aba inferior com ações.
- Controle de figurinhas repetidas.
- Filtro por:
  - Todas
  - Faltantes
  - Repetidas
- Busca por nome, país ou número da figurinha.
- Stories horizontais por seleção com progresso visual.
- Bandeiras carregadas por assets locais.

---

### Estatísticas

- Total de figurinhas carregadas.
- Total de figurinhas possuídas.
- Total de figurinhas faltantes.
- Total de repetidas.
- Quantidade de seleções.
- Progresso geral da coleção.
- Progresso por seleção.
- Destaques:
  - Figurinha mais repetida.
  - Seleção mais completa.
  - Seleção com mais faltantes.

---

### Configurações

- Atualizar catálogo a partir da API.
- Visualizar total de figurinhas carregadas.
- Ver versão do app.
- Limpar coleção salva localmente.
- Opções futuras para SAC e apoio ao desenvolvedor.

---

### Scan de páginas

- Botão flutuante de scan na tela de coleção.
- Opção de tirar foto ou importar imagem da galeria.
- Giro de imagem.
- Reconhecimento automático de texto com OCR.
- Identificação automática da seleção quando possível.
- Seleção manual caso o reconhecimento falhe.
- Geração dos códigos da página.
- Tela de confirmação das figurinhas coladas.
- Marcação em lote das figurinhas confirmadas.
- Tela de sucesso com animação de confirmação.
- Popup inicial com instruções de uso.
- Opção de “não ver novamente” após múltiplas aberturas do scan.

---

### Armazenamento local

O app salva localmente:

- Figurinhas possuídas.
- Quantidade de repetidas.
- Preferência de não exibir novamente o popup de instruções do scan.

Esse armazenamento permite que o usuário mantenha seu progresso mesmo após fechar o aplicativo.

---

## Tecnologias utilizadas

- Flutter
- Dart
- SQLite / armazenamento local
- API REST para catálogo de figurinhas
- Image Picker
- Google ML Kit Text Recognition
- Shared Preferences
- Assets locais para bandeiras e splash
- Material 3

---

## Estrutura principal do projeto

```text
lib/
 ├── data/
 ├── database/
 ├── features/
 │    └── scan/
 │         ├── models/
 │         │    └── scan_result.dart
 │         ├── pages/
 │         │    ├── scan_page.dart
 │         │    ├── scan_result_page.dart
 │         │    └── scan_success_page.dart
 │         └── services/
 │              ├── album_scan_service.dart
 │              ├── web_ocr_service.dart
 │              ├── web_ocr_service_mobile.dart
 │              └── web_ocr_service_web.dart
 ├── models/
 │    └── figurinha.dart
 ├── pages/
 │    ├── colecao_page.dart
 │    ├── configuracoes_page.dart
 │    ├── estatisticas_page.dart
 │    ├── home_page.dart
 │    └── splash_page.dart
 ├── services/
 │    └── figurinha_service.dart
 ├── storage/
 │    └── colecao_storage.dart
 ├── theme/
 │    ├── app_colors.dart
 │    └── app_theme.dart
 ├── utils/
 │    ├── album_sort.dart
 │    ├── numero_album_utils.dart
 │    └── pais_utils.dart
 ├── widgets/
 │    ├── colecao_tab_selector.dart
 │    ├── figurinha_bottom_sheet.dart
 │    ├── figurinha_grid_tile.dart
 │    ├── progresso_selecao_story_item.dart
 │    ├── secao_pais_grid.dart
 │    └── selecao_story_item.dart
 └── main.dart
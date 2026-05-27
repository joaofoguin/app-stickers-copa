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
````

---

## Modelo de figurinha

O modelo principal representa uma figurinha do catálogo.

Campos principais:

```dart
class Figurinha {
  final int id;
  final String numeroAlbum;
  final String nome;
  final String pais;
  final int ordemPais;

  bool tenho;
  int repetidas;
}
```

Observação importante:

O campo `numeroAlbum` é tratado como `String`, pois os códigos do álbum podem conter letras e números, como:

```text
MEX1
MEX10
RSA3
KOR12
```

---

## API

O app consome uma API REST para carregar o catálogo de figurinhas.

Exemplo de retorno esperado:

```json
[
  {
    "id": 1,
    "numero_album": "MEX1",
    "nome": "ESCUDO",
    "pais": "MÉXICO",
    "ordem_pais": 1
  },
  {
    "id": 2,
    "numero_album": "MEX2",
    "nome": "JOHAN VÁSQUEZ",
    "pais": "MÉXICO",
    "ordem_pais": 1
  }
]
```

Campos importantes:

| Campo          | Descrição                        |
| -------------- | -------------------------------- |
| `id`           | Identificador único da figurinha |
| `numero_album` | Código da figurinha no álbum     |
| `nome`         | Nome da figurinha ou jogador     |
| `pais`         | Seleção correspondente           |
| `ordem_pais`   | Ordem da seleção no álbum        |

---

## Ordenação das figurinhas

A ordenação considera o código do álbum de forma natural.

Exemplo correto:

```text
MEX1
MEX2
MEX3
...
MEX9
MEX10
MEX11
```

Isso evita o problema comum de ordenação alfabética, onde `MEX10` apareceria antes de `MEX2`.

---

## Assets

O projeto utiliza assets locais para:

* Bandeiras das seleções.
* Imagem de splash/loading.
* Ícone do app.

Estrutura recomendada:

```text
assets/
 ├── flags/
 │    ├── mex.png
 │    ├── rsa.png
 │    ├── kor.png
 │    ├── cze.png
 │    ├── can.png
 │    └── ...
 ├── splash/
 │    ├── splash_bg.png
 │    └── splash_logo.png
 └── icon/
      └── app_icon.png
```

No `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/flags/
    - assets/splash/
    - assets/icon/
```

---

## OCR

O app usa OCR para tentar identificar automaticamente a seleção da página escaneada.

### Mobile

No Android/iOS, o app utiliza:

```text
google_mlkit_text_recognition
```

### Web

No Flutter Web, o serviço pode utilizar uma implementação separada baseada em JavaScript.

A seleção entre implementação mobile e web é feita por import condicional:

```dart
export 'web_ocr_service_mobile.dart'
    if (dart.library.html) 'web_ocr_service_web.dart';
```

---

## Permissões Android

No arquivo:

```text
android/app/src/main/AndroidManifest.xml
```

É necessário permitir o uso da câmera:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

Essa permissão deve ficar fora da tag `<application>`.

Exemplo:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.CAMERA" />

    <application
        android:label="Álbum da Copa"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        ...
    </application>

</manifest>
```

---

## Rodando o projeto

### Instalar dependências

```bash
flutter pub get
```

### Rodar em modo debug

```bash
flutter run
```

### Rodar em modo release

```bash
flutter run --release
```

---

## Gerar APK para testes

Para gerar um APK release:

```bash
flutter build apk
```

O arquivo será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Caso ocorra erro relacionado ao R8/ML Kit no build release, use:

```bash
flutter build apk --release --no-shrink
```

---

## Gerar APK separado por arquitetura

Para gerar APKs menores:

```bash
flutter build apk --split-per-abi
```

Arquivos gerados:

```text
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

Para celulares Android atuais, normalmente utilize:

```text
app-arm64-v8a-release.apk
```

---

## Configuração do ícone do app

O projeto pode usar o pacote:

```text
flutter_launcher_icons
```

Instalação:

```bash
flutter pub add flutter_launcher_icons --dev
```

Configuração no `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#000000"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"
  min_sdk_android: 21
```

Gerar ícones:

```bash
dart run flutter_launcher_icons
```

---

## Splash screen

O app possui uma tela inicial animada com:

* Fundo visual personalizado.
* Logo central.
* Texto do app.
* Animação de entrada.

Arquivos utilizados:

```text
assets/splash/splash_bg.png
assets/splash/splash_logo.png
```

---

## Observações sobre iOS

O projeto pode ser desenvolvido no Windows, mas para compilar e instalar em iPhone físico é necessário um ambiente macOS com Xcode.

Opções possíveis:

* Usar um Mac físico.
* Usar Mac na nuvem.
* Usar GitHub Actions ou Codemagic para validar build iOS.
* Usar TestFlight com conta Apple Developer paga.

Com conta gratuita de Apple Developer, é possível testar no próprio iPhone usando Xcode, mas ainda é necessário macOS.

---

## Próximas melhorias

* Inserir catálogo completo de seleções e jogadores.
* Expandir assets de bandeiras para todas as seleções.
* Melhorar reconhecimento por página do álbum.
* Adicionar campo de página e ordem na página.
* Melhorar fluxo de troca de figurinhas repetidas.
* Criar tela de detalhes ou histórico da coleção.
* Adicionar exportação/importação de coleção.
* Sincronizar coleção com conta do usuário futuramente.

---

## Status do projeto

O app atualmente possui:

* Interface principal funcional.
* Catálogo vindo da API.
* Armazenamento local da coleção.
* Estatísticas.
* Configurações.
* Scan com OCR.
* Confirmação de figurinhas escaneadas.
* Animação de sucesso.
* Splash animada.
* Build Android funcional para testes.

---

## Autor

Desenvolvido por João Pedro Silva da Rosa Lima.

---

## Aviso legal

Este projeto é um aplicativo independente de gerenciamento de coleção de figurinhas.

O app **Álbum da Copa** não possui qualquer vínculo, parceria, afiliação, autorização ou patrocínio da FIFA, da Copa do Mundo FIFA, da Panini ou de qualquer entidade oficial relacionada a álbuns, competições, marcas, seleções ou produtos licenciados.

Todos os nomes de países, seleções e jogadores são utilizados apenas para fins informativos e de organização da coleção pelo usuário.

O projeto não utiliza marcas, logos, escudos oficiais ou materiais protegidos de terceiros com finalidade comercial. Caso algum elemento visual ou textual precise ser substituído, ele poderá ser removido ou alterado em versões futuras.

---
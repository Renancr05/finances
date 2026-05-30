# Apex Bank Digital - Flutter Android

Projeto mobile desenvolvido em Flutter para Android, simulando um aplicativo de banco digital.

O app possui tela inicial animada, login, tela principal, cotação de moedas via API, transferência com autenticação local, histórico com banco de dados SQLite, sistema de pagamento via Pix autônomo (QR Code e Copia e Cola), compartilhamento de comprovante e navegação com rotas nomeadas e argumentos.

---

## Funcionalidades

- Tela inicial com logo personalizado e animação de carregamento.
- Tela de login.
- Tela principal com boas-vindas ao usuário.
- Tela de cotação com consumo de API.
- Conversão entre Real, Dólar e Euro.
- Tela de transferência.
- Autenticação local antes da transferência.
- Histórico de transferências salvo em banco SQLite.
- Compartilhamento de comprovante de transferência.
- Rodapé reutilizável para navegação entre telas.
- Rotas nomeadas.
- Rotas nomeadas com argumentos.
- Geração de APK otimizado para Android.
- [Novo] Geração de cobrança Pix offline (QR Code e código Copia e Cola) via payload EMV.
- [Novo] Leitura de QR Code via câmera para pagamentos Pix.
- [Novo] Inserção manual de chave "Pix Copia e Cola" na tela de scanner.

---

## Tecnologias utilizadas

- Flutter
- Dart
- Android
- SQLite
- API HG Brasil Finance

---

## Principais comandos no terminal

-Limpar e baixar dependências novamente (Windows/Linux):

flutter clean
flutter pub get

-Ver dispositivos conectados (Windows/Linux):

flutter devices

-Gerar APK otimizado por arquitetura (Windows/Linux):

flutter build apk

-Gerar APK otimizado para Produção (Release) - Adicionado (Windows/Linux):

flutter build apk --release

-Comandos relacionados ao Android/ADB Ir para a pasta do ADB:

Windows:
cd "$env:LOCALAPPDATA\Android\Sdk\platform-tools"

Linux/macOS:
cd ~/Android/Sdk/platform-tools

-Reiniciar o ADB:

Windows:
.\adb.exe kill-server
.\adb.exe start-server

Linux/macOS:
adb kill-server
adb start-server

-Ver dispositivos Android reconhecidos pelo ADB:

Windows:
.\adb.exe devices

Linux/macOS:
adb devices

-O ideal é aparecer:

emulator-5554    device

-Comandos para resolver problemas comuns, ativar modo desenvolvedor do Windows, Use quando aparecer erro de symlink:

start ms-settings:developers

---

## Plugins utilizados

No arquivo `pubspec.yaml`, foram utilizados os seguintes plugins:

```yaml
dependencies:
  flutter:
    sdk: flutter

  http: ^0.13.4
  share_plus: ^11.0.0
  sqflite: ^2.3.0
  path: ^1.9.0
  local_auth: ^3.0.1
  qr_flutter: ^4.1.0
  mobile_scanner: ^5.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^5.0.0
  flutter_launcher_icons: ^0.14.4

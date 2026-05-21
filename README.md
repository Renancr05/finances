# Apex Bank Digital - Flutter Android

Projeto mobile desenvolvido em Flutter para Android, simulando um aplicativo de banco digital.

O app possui tela inicial animada, login, tela principal, cotação de moedas via API, transferência com autenticação local, histórico com banco de dados SQLite, compartilhamento de comprovante e navegação com rotas nomeadas e argumentos.

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

---

## Tecnologias utilizadas

- Flutter
- Dart
- Android
- SQLite
- API HG Brasil Finance

---

## Principais comandos no terminal

-Limpar e baixar dependências novamente:

flutter clean
flutter pub get

-Ver dispositivos conectados:

flutter devices

-Gerar APK otimizado por arquitetura:

flutter build apk --split-per-abi

-Comandos relacionados ao Android/ADB Ir para a pasta do ADB:

cd "$env:LOCALAPPDATA\Android\Sdk\platform-tools"

-Reiniciar o ADB:

.\adb.exe kill-server
.\adb.exe start-server

-Ver dispositivos Android reconhecidos pelo ADB:

.\adb.exe devices

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

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^5.0.0
  flutter_launcher_icons: ^0.14.4

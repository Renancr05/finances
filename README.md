# Banco Digital - Flutter Android

Projeto mobile desenvolvido em Flutter para Android, simulando um Banco Digital com acesso a banco de dados local.

O aplicativo possui tela de login, tela principal, consulta de cotação via API, tela de transferência, histórico de transferências salvo em banco SQLite e uso de rotas nomeadas com argumentos.

---

## Funcionalidades

- Login de usuário.
- Tela principal com dados do usuário.
- Cotação de moedas via API.
- Conversão entre Real, Dólar e Euro.
- Transferência bancária simulada.
- Histórico de transferências.
- Banco de dados local SQLite.
- Compartilhamento de comprovante.
- Rotas nomeadas.
- Rotas nomeadas com argumentos.
- Geração de APK Android.

---

## Tecnologias utilizadas

- Flutter.
- Dart.
- Android.
- SQLite.
- API HG Brasil Finance.

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

# Conversor de Moedas Finance

Aplicativo desenvolvido em Flutter para conversão de moedas entre Real, Dólar e Euro.

## Funcionalidades

- Conversão de Real para Dólar
- Conversão de Real para Euro
- Conversão de Dólar para Real
- Conversão de Euro para Real
- Consumo de API externa de cotações
- Formatação monetária

## Plugins utilizados

- http: utilizado para consumir a API de cotações
- intl: utilizado para formatar valores monetários

## API utilizada

AwesomeAPI - Economia
Endpoint utilizado:

https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL

## APK

O APK split deverá ser gerado pelo comando:

flutter build apk --split-per-abi

Após a geração, os arquivos ficarão em:

build/app/outputs/flutter-apk/

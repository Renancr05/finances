import 'package:flutter/foundation.dart';

class ValidadorPayload {
  static bool validarPix(String payload) {
    String codigo = payload.trim();
    if (codigo.isEmpty || codigo.length < 25) {
      debugPrint('Validação falhou: Carga útil muito curta ou vazia.');
      return false;
    }

    if (!codigo.startsWith('000201')) {
      debugPrint('Validação falhou: Indicador de formato EMV inválido.');
      return false;
    }

    if (!codigo.contains('26')) {
      debugPrint(
        'Validação falhou: Tag de identificação do arranjo Pix ausente.',
      );
      return false;
    }

    final regexCRC = RegExp(r'6304[0-9A-Fa-f]{4}$');
    if (!regexCRC.hasMatch(codigo)) {
      debugPrint('Validação falhou: Checksum CRC16 malformado ou ausente.');
      return false;
    }

    debugPrint('Validação bem-sucedida: Payload íntegro.');
    return true;
  }

  static double? extrairValor(String payload) {
    try {
      String codigo = payload.trim();
      int i = 0;

      while (i < codigo.length) {
        if (i + 4 > codigo.length) break;

        String tag = codigo.substring(i, i + 2);
        int? len = int.tryParse(codigo.substring(i + 2, i + 4));

        if (len == null) break;
        if (i + 4 + len > codigo.length) break;

        String value = codigo.substring(i + 4, i + 4 + len);

        if (tag == '54') {
          return double.tryParse(value);
        }

        i += 4 + len;
      }
    } catch (e) {
      debugPrint('Erro ao processar as tags de valor do Pix: $e');
    }
    return null;
  }
}

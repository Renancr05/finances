class PixGenerator {
  static String gerarPayload({
    required String chavePix,
    required double valor,
    required String nomeDestinatario,
  }) {
    final strValor = valor.toStringAsFixed(2);

    // Montagem interna da Tag 26 (Conta do Merchant)
    const gui = "0014br.gov.bcb.pix";
    final chave = "01${chavePix.length.toString().padLeft(2, '0')}$chavePix";
    final tamTag26 = (gui.length + chave.length).toString().padLeft(2, '0');

    final tag00 = "000201";
    final tag26 = "26$tamTag26$gui$chave";
    final tag52 = "52040000";
    final tag53 = "5303986";
    final tag54 = "54${strValor.length.toString().padLeft(2, '0')}$strValor";
    final tag58 = "5802BR";
    final tag59 =
        "59${nomeDestinatario.length.toString().padLeft(2, '0')}$nomeDestinatario";
    final tag60 = "6009SAO PAULO"; // Cidade padrão válida
    final tag63 = "6304";

    final payloadSemCrc =
        "$tag00$tag26$tag52$tag53$tag54$tag58$tag59$tag60$tag63";

    // O final do Pix não pode ser "0000". Ele precisa do cálculo real do CRC16.
    return "$payloadSemCrc${_calcularCRC16(payloadSemCrc)}";
  }

  static String _calcularCRC16(String texto) {
    int crc = 0xFFFF;
    for (int byte in texto.codeUnits) {
      for (int i = 0; i < 8; i++) {
        bool bit = ((byte >> (7 - i) & 1) == 1);
        bool c15 = ((crc >> 15 & 1) == 1);
        crc <<= 1;
        if (c15 ^ bit) crc ^= 0x1021;
      }
    }
    return (crc & 0xFFFF).toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}

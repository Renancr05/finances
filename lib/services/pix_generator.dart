import 'dart:convert';

class PixGenerator {
  static String gerarPayload(double valor, String nomeDestinatario) {
    String tag00 = "000201";
    String tag26 = "26" + (22 + nomeDestinatario.length).toString().padLeft(2, '0') + "0014br.gov.bcb.pix01" + nomeDestinatario.length.toString().padLeft(2, '0') + nomeDestinatario;
    String tag52 = "52040000";
    String tag53 = "5303986";
    String tag54 = "54" + valor.toStringAsFixed(2).length.toString().padLeft(2, '0') + valor.toStringAsFixed(2);
    String tag58 = "5802BR";
    String tag59 = "59" + nomeDestinatario.length.toString().padLeft(2, '0') + nomeDestinatario;
    String tag60 = "6004CABA";
    String tag63 = "6304";

    String payload = tag00 + tag26 + tag52 + tag53 + tag54 + tag58 + tag59 + tag60 + tag63;
    
    return payload + "0000"; 
  }
}

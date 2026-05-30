import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'argumentos.dart';
import 'banco.dart';
import 'leitor_qr_code.dart';
import 'services/pix_generator.dart';
import 'services/validador_payload.dart';
import 'widgets/rodape_banco.dart';

class Transferencia extends StatefulWidget {
  const Transferencia({super.key});

  @override
  State<Transferencia> createState() => _TransferenciaState();
}

class _TransferenciaState extends State<Transferencia> {
  final nomeDestinoController = TextEditingController();
  final contaDestinoController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void dispose() {
    nomeDestinoController.dispose();
    contaDestinoController.dispose();
    valorController.dispose();
    super.dispose();
  }

  Future<void> _registrarTransacao(
    String tipo,
    double valor,
    String descricao,
  ) async {
    await BancoHelper().inserirTransferencia({
      'nomeDestino': descricao,
      'contaDestino': 'Pix Apex Bank',
      'valor': tipo == 'debito' ? valor : valor,
      'data': DateTime.now().toString(),
    });
  }

  Future<void> _compartilharPix(String copiaECola, String nomeUsuario) async {
    try {
      final painter = QrPainter(
        data: copiaECola,
        version: QrVersions.auto,
        // Configuração atualizada para as versões mais recentes do qr_flutter
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF143D36),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF143D36),
        ),
      );

      final picData = await painter.toImageData(
        1024,
        format: ImageByteFormat.png,
      );

      if (picData != null) {
        final tempDir = Directory.systemTemp;
        final file = await File('${tempDir.path}/qr_apex_bank.png').create();
        await file.writeAsBytes(picData.buffer.asUint8List());

        // Nova sintaxe obrigatória nas versões mais recentes do share_plus
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text:
                'Cobrança de $nomeUsuario via Apex Bank.\n\nCódigo Copia e Cola:\n$copiaECola',
            subject: 'Cobrança Pix - Apex Bank',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao compartilhar: $e')));
      }
    }
  }

  void _modalGerarPix(String nomeUsuario) {
    final TextEditingController vCtrl = TextEditingController();
    String? copiaECola;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Receber via Pix',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF143D36),
                ),
              ),
              if (copiaECola == null) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: vCtrl,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Color(0xFF143D36)),
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    prefixText: 'R\$ ',
                    labelStyle: const TextStyle(color: Color(0xFF143D36)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF143D36),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      final val = double.tryParse(
                        vCtrl.text.replaceAll(',', '.'),
                      );
                      if (val != null && val > 0) {
                        await _registrarTransacao(
                          'credito',
                          val,
                          'Recebido Pix',
                        );
                        setModalState(
                          () => copiaECola = PixGenerator.gerarPayload(
                            chavePix: "suachave@apexbank.com",
                            valor: val,
                            nomeDestinatario: nomeUsuario.isNotEmpty
                                ? nomeUsuario
                                : "ApexBank",
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Gerar QR Code',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                QrImageView(
                  data: copiaECola!,
                  size: 200,
                  backgroundColor:
                      Colors.white, // Garante visibilidade no dark mode
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF143D36),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF143D36),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Registrado como entrada no histórico.',
                  style: TextStyle(
                    color: Color(0xFF143D36),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF48D6C5),
                      foregroundColor: const Color(0xFF143D36),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () => _compartilharPix(copiaECola!, nomeUsuario),
                    icon: const Icon(Icons.share),
                    label: const Text(
                      'Compartilhar Pix',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _abrirLeitorQrCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeitorQrCode()),
    );
    if (result != null &&
        result is String &&
        ValidadorPayload.validarPix(result)) {
      double? valor = ValidadorPayload.extrairValor(result);
      _confirmarPagamento(valor ?? 0.0);
    }
  }

  void _confirmarPagamento(double valor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Confirmar Pagamento',
          style: TextStyle(color: Color(0xFF143D36)),
        ),
        content: Text(
          'Confirmar pagamento de R\$ ${valor.toStringAsFixed(2)}?',
          style: const TextStyle(color: Color(0xFF143D36)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final bool autenticado = await autenticarUsuario();
              if (!mounted || !autenticado) return;

              await _registrarTransacao('debito', valor, 'Pagamento Pix');

              if (mounted) {
                await _mostrarTransferenciaConcluida();
              }
            },
            child: const Text(
              'Confirmar',
              style: TextStyle(
                color: Color(0xFF48D6C5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> autenticarUsuario() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool dispositivoSuportado = await auth.isDeviceSupported();
      final bool podeChecarBiometria = await auth.canCheckBiometrics;
      if (!mounted) return false;
      if (!dispositivoSuportado && !podeChecarBiometria) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticação não disponível neste dispositivo.'),
          ),
        );
        return false;
      }
      return await auth.authenticate(
        localizedReason:
            'Confirme sua identidade para realizar a transferência',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro na autenticação tente novamente.'),
          ),
        );
      }
      return false;
    }
  }

  Future<void> enviarTransferencia() async {
    if (nomeDestinoController.text.isEmpty ||
        contaDestinoController.text.isEmpty ||
        valorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    double valor = double.parse(valorController.text.replaceAll(',', '.'));

    final bool autenticado = await autenticarUsuario();
    if (!mounted || !autenticado) return;

    await BancoHelper().inserirTransferencia({
      'nomeDestino': nomeDestinoController.text,
      'contaDestino': contaDestinoController.text,
      'valor': valor,
      'data': DateTime.now().toString(),
    });

    if (!mounted) return;
    await _mostrarTransferenciaConcluida();

    if (mounted) {
      nomeDestinoController.clear();
      contaDestinoController.clear();
      valorController.clear();
    }
  }

  Future<void> _mostrarTransferenciaConcluida() async {
    final w = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            builder: (context, valorAnimacao, child) {
              return Transform.scale(
                scale: valorAnimacao,
                child: Opacity(
                  opacity: valorAnimacao.clamp(0.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: (w * 0.22).clamp(70.0, 95.0),
                          height: (w * 0.22).clamp(70.0, 95.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF48D6C5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: (w * 0.14).clamp(42.0, 62.0),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Transferência concluída',
                          style: TextStyle(
                            color: Color(0xFF143D36),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Sua transferência foi enviada com sucesso.',
                          style: TextStyle(
                            color: Color(0xFF143D36),
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UsuarioArgumentos;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3F0),
      appBar: AppBar(
        title: const Text('Transferência'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16.0,
          24.0,
          16.0,
          MediaQuery.of(context).padding.bottom + 32.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo_apex.png',
                width: (w * 0.35).clamp(120.0, 180.0),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Conta de origem',
                    style: TextStyle(color: Color(0xFF143D36), fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    args.conta,
                    style: const TextStyle(
                      color: Color(0xFF143D36),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF48D6C5),
                      foregroundColor: const Color(0xFF143D36),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _abrirLeitorQrCode,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text(
                      'Pagar Pix',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF143D36),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () => _modalGerarPix(args.nome),
                    icon: const Icon(Icons.qr_code),
                    label: const Text(
                      'Receber Pix',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.swap_horiz,
                    size: (w * 0.20).clamp(60.0, 90.0),
                    color: const Color(0xFF143D36),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nomeDestinoController,
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-ZÀ-ÿ ]'),
                      ),
                    ],
                    style: const TextStyle(color: Color(0xFF143D36)),
                    decoration: InputDecoration(
                      labelText: 'Nome do destinatário',
                      labelStyle: const TextStyle(color: Color(0xFF143D36)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contaDestinoController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(color: Color(0xFF143D36)),
                    decoration: InputDecoration(
                      labelText: 'Conta de destino',
                      labelStyle: const TextStyle(color: Color(0xFF143D36)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(color: Color(0xFF143D36)),
                    decoration: InputDecoration(
                      labelText: 'Valor',
                      prefixText: 'R\$ ',
                      labelStyle: const TextStyle(color: Color(0xFF143D36)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF143D36),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: enviarTransferencia,
                    child: const Text(
                      'Fazer transferência',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RodapeBanco(args: args, telaAtiva: 'transferencia'),
    );
  }
}

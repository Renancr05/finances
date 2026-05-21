import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'argumentos.dart';
import 'banco.dart';
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

      final bool autenticado = await auth.authenticate(
        localizedReason:
            'Confirme sua identidade para realizar a transferência',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      return autenticado;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro na autenticação: $e')));

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

    if (!mounted) return;

    if (!autenticado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transferência cancelada. Autenticação não realizada.'),
        ),
      );
      return;
    }

    await BancoHelper().inserirTransferencia({
      'nomeDestino': nomeDestinoController.text,
      'contaDestino': contaDestinoController.text,
      'valor': valor,
      'data': DateTime.now().toString(),
    });

    if (!mounted) return;

    await _mostrarTransferenciaConcluida();

    if (!mounted) return;

    nomeDestinoController.clear();
    contaDestinoController.clear();
    valorController.clear();
  }

  Future<void> _mostrarTransferenciaConcluida() async {
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
                          width: 95,
                          height: 95,
                          decoration: const BoxDecoration(
                            color: Color(0xFF48D6C5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 62,
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
                          'Sua transferência foi autenticada e enviada com sucesso.',
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

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3F0),
      appBar: AppBar(
        title: const Text('Transferência'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset('assets/images/logo_apex.png', width: 150),
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
                    color: Colors.black..withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Conta de origem',
                    style: const TextStyle(
                      color: Color(0xFF143D36),
                      fontSize: 16,
                    ),
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

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black..withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.swap_horiz,
                    size: 90,
                    color: Color(0xFF143D36),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: nomeDestinoController,
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
                    style: const TextStyle(color: Color(0xFF143D36)),
                    decoration: InputDecoration(
                      labelText: 'Valor',
                      labelStyle: const TextStyle(color: Color(0xFF143D36)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 31, 105, 93),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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

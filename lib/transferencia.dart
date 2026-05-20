import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'argumentos.dart';
import 'banco.dart';

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

    await _mostrarTransferenciaConcluida();

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
                    color: Colors.black.withOpacity(0.08),
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
                    color: Colors.black.withOpacity(0.08),
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
                      backgroundColor: const Color(0xFF143D36),
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
      bottomNavigationBar: _rodape(context, args),
    );
  }

  Widget _rodape(BuildContext context, UsuarioArgumentos args) {
    return SizedBox(
      height: 108,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 84,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _itemRodape(
                    icone: Icons.account_balance,
                    texto: 'Início',
                    ativo: false,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/principal',
                        arguments: args,
                      );
                    },
                  ),
                  _itemRodape(
                    icone: Icons.currency_exchange,
                    texto: 'Cotação',
                    ativo: false,
                    onTap: () {
                      Navigator.pushNamed(context, '/cotacao', arguments: args);
                    },
                  ),
                  const SizedBox(width: 82),
                  _itemRodape(
                    icone: Icons.history,
                    texto: 'Histórico',
                    ativo: false,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/historico',
                        arguments: args,
                      );
                    },
                  ),
                  _itemRodape(
                    icone: Icons.logout,
                    texto: 'Sair',
                    ativo: false,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: const Color(0xFF48D6C5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF48D6C5).withOpacity(0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ),
          ),

          const Positioned(
            top: 80,
            child: Text(
              'Transferência',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRodape({
    required IconData icone,
    required String texto,
    required bool ativo,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icone,
              size: 30,
              color: ativo ? const Color(0xFF143D36) : Colors.black87,
            ),
            const SizedBox(height: 4),
            Text(
              texto,
              style: TextStyle(
                color: ativo ? const Color(0xFF143D36) : Colors.black87,
                fontSize: 13,
                fontWeight: ativo ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'argumentos.dart';
import 'widgets/rodape_banco.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UsuarioArgumentos;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3F0),
      appBar: AppBar(
        title: const Text('Aplex Bank'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_apex.png', width: 190),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
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
                      'Bem-vindo, ${args.nome}',
                      style: const TextStyle(
                        color: Color(0xFF143D36),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Conta: ${args.conta}',
                      style: const TextStyle(
                        color: Color(0xFF143D36),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RodapeBanco(args: args, telaAtiva: 'inicio'),
    );
  }
}

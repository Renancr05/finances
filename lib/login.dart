import 'package:flutter/material.dart';

import 'argumentos.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final nomeController = TextEditingController();
  final contaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    contaController.dispose();
    super.dispose();
  }

  void entrar() {
    if (nomeController.text.isEmpty || contaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe seu nome e número da conta.')),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/principal',
      arguments: UsuarioArgumentos(
        nome: nomeController.text,
        conta: contaController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3F0),
      appBar: AppBar(
        title: const Text('Apex Bank'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Acesse sua conta',
                      style: TextStyle(
                        color: Color(0xFF143D36),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Informe seus dados para entrar',
                      style: TextStyle(color: Color(0xFF143D36), fontSize: 15),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 28),

                    TextField(
                      controller: nomeController,
                      style: const TextStyle(color: Color(0xFF143D36)),
                      decoration: InputDecoration(
                        labelText: 'Nome do usuário',
                        labelStyle: const TextStyle(color: Color(0xFF143D36)),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF143D36),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: contaController,
                      style: const TextStyle(color: Color(0xFF143D36)),
                      decoration: InputDecoration(
                        labelText: 'Número da conta',
                        labelStyle: const TextStyle(color: Color(0xFF143D36)),
                        prefixIcon: const Icon(
                          Icons.account_balance,
                          color: Color(0xFF143D36),
                        ),
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
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: entrar,
                      child: const Text(
                        'Entrar',
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
      ),
    );
  }
}

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_balance, size: 120, color: Colors.green),
            const SizedBox(height: 20),
            TextField(
              controller: nomeController,
              style: const TextStyle(color: Colors.green),
              decoration: const InputDecoration(
                labelText: 'Nome do usuário',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contaController,
              style: const TextStyle(color: Colors.green),
              decoration: const InputDecoration(
                labelText: 'Número da conta',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: entrar, child: const Text('Entrar')),
          ],
        ),
      ),
    );
  }
}

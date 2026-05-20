import 'package:flutter/material.dart';

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

  Future<void> salvarTransferencia() async {
    if (nomeDestinoController.text.isEmpty ||
        contaDestinoController.text.isEmpty ||
        valorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    double valor = double.parse(valorController.text);

    await BancoHelper().inserirTransferencia({
      'nomeDestino': nomeDestinoController.text,
      'contaDestino': contaDestinoController.text,
      'valor': valor,
      'data': DateTime.now().toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transferência salva com sucesso.')),
    );

    nomeDestinoController.clear();
    contaDestinoController.clear();
    valorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UsuarioArgumentos;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Transferência'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Conta de origem: ${args.conta}',
              style: const TextStyle(color: Colors.green, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nomeDestinoController,
              style: const TextStyle(color: Colors.green),
              decoration: const InputDecoration(
                labelText: 'Nome do destinatário',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contaDestinoController,
              style: const TextStyle(color: Colors.green),
              decoration: const InputDecoration(
                labelText: 'Conta de destino',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valorController,
              style: const TextStyle(color: Colors.green),
              decoration: const InputDecoration(
                labelText: 'Valor',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
                prefixText: 'R\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: salvarTransferencia,
              child: const Text('Salvar Transferência'),
            ),
          ],
        ),
      ),
    );
  }
}

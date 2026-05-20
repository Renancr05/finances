import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'argumentos.dart';
import 'banco.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  List<Map<String, dynamic>> transferencias = [];

  @override
  void initState() {
    super.initState();
    carregarHistorico();
  }

  Future<void> carregarHistorico() async {
    final dados = await BancoHelper().listarTransferencias();

    setState(() {
      transferencias = dados;
    });
  }

  Future<void> excluirItem(int id) async {
    await BancoHelper().excluirTransferencia(id);
    carregarHistorico();
  }

  Future<void> compartilhar(Map<String, dynamic> item) async {
    await Share.share(
      'Comprovante de transferência\n'
      'Destinatário: ${item['nomeDestino']}\n'
      'Conta destino: ${item['contaDestino']}\n'
      'Valor: R\$ ${item['valor']}\n'
      'Data: ${item['data']}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UsuarioArgumentos;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: transferencias.isEmpty
          ? Center(
              child: Text(
                'Nenhuma transferência encontrada.\nUsuário: ${args.nome}',
                style: const TextStyle(color: Colors.green, fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: transferencias.length,
              itemBuilder: (context, index) {
                final item = transferencias[index];

                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(
                      '${item['nomeDestino']} - R\$ ${item['valor']}',
                      style: const TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    subtitle: Text(
                      'Conta: ${item['contaDestino']}\nData: ${item['data']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.green),
                          onPressed: () {
                            compartilhar(item);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            excluirItem(item['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

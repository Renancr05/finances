import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'argumentos.dart';
import 'banco.dart';
import 'widgets/rodape_banco.dart';

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

    if (!mounted) return;

    setState(() {
      transferencias = dados;
    });
  }

  Future<void> excluirItem(int id) async {
    await BancoHelper().excluirTransferencia(id);

    if (!mounted) return;

    carregarHistorico();
  }

  String formatarDataBrasil(String data) {
    DateTime dateTime = DateTime.parse(data);

    String dia = dateTime.day.toString().padLeft(2, '0');
    String mes = dateTime.month.toString().padLeft(2, '0');
    String ano = dateTime.year.toString();

    String hora = dateTime.hour.toString().padLeft(2, '0');
    String minuto = dateTime.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$ano $hora:$minuto';
  }

  String formatarValorBrasil(dynamic valor) {
    double numero = double.parse(valor.toString());

    String valorFormatado = numero.toStringAsFixed(2);

    return valorFormatado.replaceAll('.', ',');
  }

  Future<void> compartilhar(Map<String, dynamic> item) async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Comprovante de transferência\n'
            'Destinatário: ${item['nomeDestino']}\n'
            'Conta destino: ${item['contaDestino']}\n'
            'Valor: R\$ ${formatarValorBrasil(item['valor'])}\n'
            'Data: ${formatarDataBrasil(item['data'])}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UsuarioArgumentos;

    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3F0),
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(
                context,
                '/principal',
                arguments: args,
              );
            }
          },
        ),
      ),
      body: transferencias.isEmpty
          ? SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16.0,
                24.0,
                16.0,
                MediaQuery.of(context).padding.bottom + 32.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top -
                      108,
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo_apex.png',
                          width: (w * 0.35).clamp(120.0, 180.0),
                        ),
                        const SizedBox(height: 24),
                        Icon(
                          Icons.history,
                          size: (w * 0.17).clamp(55.0, 80.0),
                          color: const Color(0xFF143D36),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Nenhuma transferência encontrada.',
                          style: TextStyle(
                            color: Color(0xFF143D36),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Usuário: ${args.nome}',
                          style: const TextStyle(
                            color: Color(0xFF143D36),
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16.0,
                24.0,
                16.0,
                MediaQuery.of(context).padding.bottom + 32.0,
              ),
              itemCount: transferencias.length,
              itemBuilder: (context, index) {
                final item = transferencias[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF48D6C5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.swap_horiz,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      '${item['nomeDestino']}',
                      style: const TextStyle(
                        color: Color(0xFF143D36),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Conta: ${item['contaDestino']}\n'
                        'Valor: R\$ ${formatarValorBrasil(item['valor'])}\n'
                        'Data: ${formatarDataBrasil(item['data'])}',
                        style: const TextStyle(
                          color: Color(0xFF143D36),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Color(0xFF143D36),
                          ),
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
      bottomNavigationBar: RodapeBanco(args: args, telaAtiva: 'historico'),
    );
  }
}

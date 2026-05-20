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
      backgroundColor: const Color(0xFFEAF3F0),
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: transferencias.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 120.0),
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo_apex.png', width: 150),
                      const SizedBox(height: 24),
                      const Icon(
                        Icons.history,
                        size: 70,
                        color: Color(0xFF143D36),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Nenhuma transferência encontrada.',
                        style: const TextStyle(
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
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 120.0),
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
                        color: Colors.black.withOpacity(0.08),
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
                        'Valor: R\$ ${item['valor']}\n'
                        'Data: ${item['data']}',
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
                    ativo: true,
                    onTap: () {},
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
              onTap: () {
                Navigator.pushNamed(context, '/transferencia', arguments: args);
              },
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

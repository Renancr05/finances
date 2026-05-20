import 'package:flutter/material.dart';

import 'argumentos.dart';

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
                    ativo: true,
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

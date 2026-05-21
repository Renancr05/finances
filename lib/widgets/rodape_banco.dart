import 'package:flutter/material.dart';

import '../argumentos.dart';

class RodapeBanco extends StatelessWidget {
  final UsuarioArgumentos args;
  final String telaAtiva;

  const RodapeBanco({super.key, required this.args, required this.telaAtiva});

  @override
  Widget build(BuildContext context) {
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
                    context: context,
                    icone: Icons.account_balance,
                    texto: 'Início',
                    ativo: telaAtiva == 'inicio',
                    onTap: () {
                      if (telaAtiva == 'inicio') return;

                      Navigator.pushNamed(
                        context,
                        '/principal',
                        arguments: args,
                      );
                    },
                  ),
                  _itemRodape(
                    context: context,
                    icone: Icons.currency_exchange,
                    texto: 'Cotação',
                    ativo: telaAtiva == 'cotacao',
                    onTap: () {
                      if (telaAtiva == 'cotacao') return;

                      Navigator.pushNamed(context, '/cotacao', arguments: args);
                    },
                  ),
                  const SizedBox(width: 82),
                  _itemRodape(
                    context: context,
                    icone: Icons.history,
                    texto: 'Histórico',
                    ativo: telaAtiva == 'historico',
                    onTap: () {
                      if (telaAtiva == 'historico') return;

                      Navigator.pushNamed(
                        context,
                        '/historico',
                        arguments: args,
                      );
                    },
                  ),
                  _itemRodape(
                    context: context,
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
                if (telaAtiva == 'transferencia') return;

                Navigator.pushNamed(context, '/transferencia', arguments: args);
              },
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: telaAtiva == 'transferencia'
                      ? const Color(0xFF143D36)
                      : const Color(0xFF48D6C5),
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
    required BuildContext context,
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

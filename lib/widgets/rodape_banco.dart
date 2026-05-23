import 'package:flutter/material.dart';

import '../argumentos.dart';

class RodapeBanco extends StatelessWidget {
  final UsuarioArgumentos args;
  final String telaAtiva;

  const RodapeBanco({super.key, required this.args, required this.telaAtiva});

  @override
  Widget build(BuildContext context) {
    final EdgeInsets sysPadding = MediaQuery.of(context).padding;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Dimensões adaptativas: menores em paisagem
    final double outerHeight =
        (isLandscape ? 62.0 : 108.0) + sysPadding.bottom;
    final double containerHeight =
        (isLandscape ? 54.0 : 84.0) + sysPadding.bottom;
    final double circleSize = isLandscape ? 44.0 : 78.0;
    final double circleIconSize = isLandscape ? 24.0 : 42.0;
    final double iconSize = isLandscape ? 20.0 : 30.0;
    final double fontSize = isLandscape ? 10.0 : 13.0;
    final double labelTop = isLandscape ? 50.0 : 80.0;
    final double spacerWidth = isLandscape ? 54.0 : 82.0;
    final double itemWidth = isLandscape ? 52.0 : 68.0;

    return SizedBox(
      height: outerHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: containerHeight,
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
              child: Padding(
                padding: EdgeInsets.only(bottom: sysPadding.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _itemRodape(
                      context: context,
                      icone: Icons.account_balance,
                      texto: 'Início',
                      ativo: telaAtiva == 'inicio',
                      iconSize: iconSize,
                      fontSize: fontSize,
                      itemWidth: itemWidth,
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
                      iconSize: iconSize,
                      fontSize: fontSize,
                      itemWidth: itemWidth,
                      onTap: () {
                        if (telaAtiva == 'cotacao') return;
                        Navigator.pushNamed(
                          context,
                          '/cotacao',
                          arguments: args,
                        );
                      },
                    ),
                    SizedBox(width: spacerWidth),
                    _itemRodape(
                      context: context,
                      icone: Icons.history,
                      texto: 'Histórico',
                      ativo: telaAtiva == 'historico',
                      iconSize: iconSize,
                      fontSize: fontSize,
                      itemWidth: itemWidth,
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
                      iconSize: iconSize,
                      fontSize: fontSize,
                      itemWidth: itemWidth,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
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
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: telaAtiva == 'transferencia'
                      ? const Color(0xFF143D36)
                      : const Color(0xFF48D6C5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF48D6C5)..withValues(alpha: 0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: Colors.white,
                  size: circleIconSize,
                ),
              ),
            ),
          ),

          Positioned(
            top: labelTop,
            child: Text(
              'Transferência',
              style: TextStyle(color: Colors.black, fontSize: fontSize),
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
    required double iconSize,
    required double fontSize,
    required double itemWidth,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icone,
              size: iconSize,
              color: ativo ? const Color(0xFF143D36) : Colors.black87,
            ),
            const SizedBox(height: 4),
            Text(
              texto,
              style: TextStyle(
                color: ativo ? const Color(0xFF143D36) : Colors.black87,
                fontSize: fontSize,
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

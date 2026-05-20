import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'argumentos.dart';

Future<Map> getData() async {
  String formato = kIsWeb ? 'json-cors' : 'json';

  var url = Uri.parse(
    'https://api.hgbrasil.com/finance?format=$formato&key=878111f3',
  );

  http.Response response = await http.get(url);

  return json.decode(response.body);
}

class Cotacao extends StatefulWidget {
  const Cotacao({super.key});

  @override
  State<Cotacao> createState() => _CotacaoState();
}

class _CotacaoState extends State<Cotacao> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar = 0.0;
  double euro = 0.0;

  VoidCallback? _realChanged(String text) {
    double real = double.parse(text);

    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);

    return null;
  }

  VoidCallback? _dolarChanged(String text) {
    double dolar = double.parse(text);

    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);

    return null;
  }

  VoidCallback? _euroChanged(String text) {
    double euro = double.parse(text);

    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

    return null;
  }

  @override
  void dispose() {
    realController.dispose();
    dolarController.dispose();
    euroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as UsuarioArgumentos;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3F0),
      appBar: AppBar(
        title: const Text('Cotação'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF143D36),
                ),
              );

            default:
              if (snapshot.hasError) {
                String? erro = snapshot.error.toString();

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Ops, houve uma falha ao buscar os dados : $erro',
                      style: const TextStyle(
                        color: Color(0xFF143D36),
                        fontSize: 22.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                euro = snapshot.data!['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 120.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/images/logo_apex.png',
                          width: 150,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
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
                              'Usuário: ${args.nome}',
                              style: const TextStyle(
                                color: Color(0xFF143D36),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Conta: ${args.conta}',
                              style: const TextStyle(
                                color: Color(0xFF143D36),
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
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
                            const Icon(
                              Icons.currency_exchange,
                              size: 90.0,
                              color: Color(0xFF143D36),
                            ),

                            const SizedBox(height: 20),

                            campoTexto(
                              'Reais',
                              'R\$ ',
                              realController,
                              _realChanged,
                            ),

                            const SizedBox(height: 16),

                            campoTexto(
                              'Euros',
                              '€ ',
                              euroController,
                              _euroChanged,
                            ),

                            const SizedBox(height: 16),

                            campoTexto(
                              'Dólares',
                              'US\$ ',
                              dolarController,
                              _dolarChanged,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
      bottomNavigationBar: _rodape(context, args),
    );
  }

  Widget campoTexto(
    String label,
    String prefix,
    TextEditingController c,
    Function? f,
  ) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF143D36)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        prefixText: prefix,
      ),
      style: const TextStyle(color: Color(0xFF143D36), fontSize: 22.0),
      onChanged: (value) => {f!(value)},
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    ativo: true,
                    onTap: () {},
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

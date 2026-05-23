import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'argumentos.dart';
import 'widgets/rodape_banco.dart';

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
                child: CircularProgressIndicator(color: Color(0xFF143D36)),
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
                final w = MediaQuery.of(context).size.width;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    24.0,
                    16.0,
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).padding.bottom + 16.0
                        : MediaQuery.of(context).padding.bottom + 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/images/logo_apex.png',
                          width: w * 0.35,
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
                              color: Colors.black.withValues(alpha: 0.08),
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
                              color: Colors.black..withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.currency_exchange,
                              size: w * 0.20,
                              color: const Color(0xFF143D36),
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
      bottomNavigationBar: RodapeBanco(args: args, telaAtiva: 'cotacao'),
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
}

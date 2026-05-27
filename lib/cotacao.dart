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

  void _clearFields() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearFields();
      return;
    }
    double real = double.tryParse(text) ?? 0.0;
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearFields();
      return;
    }
    double dolarConvertido = double.tryParse(text) ?? 0.0;
    realController.text = (dolarConvertido * dolar).toStringAsFixed(2);
    euroController.text = (dolarConvertido * dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearFields();
      return;
    }
    double euroConvertido = double.tryParse(text) ?? 0.0;
    realController.text = (euroConvertido * euro).toStringAsFixed(2);
    dolarController.text = (euroConvertido * euro / dolar).toStringAsFixed(2);
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
                return _buildErrorWidget(snapshot.error.toString());
              } else if (snapshot.data == null ||
                  !snapshot.data!.containsKey('results')) {
                return _buildErrorWidget(
                  "Os dados da API estão indisponíveis.",
                );
              } else {
                dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                euro = snapshot.data!['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    24.0,
                    16.0,
                    MediaQuery.of(context).padding.bottom + 32.0,
                  ),
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
                              color: Colors.black.withValues(alpha: 0.08),
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
      bottomNavigationBar: RodapeBanco(args: args, telaAtiva: 'cotacao'),
    );
  }

  Widget _buildErrorWidget(String erro) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Ops, houve uma falha ao buscar os dados: $erro',
          style: const TextStyle(color: Color(0xFF143D36), fontSize: 22.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget campoTexto(
    String label,
    String prefix,
    TextEditingController c,
    void Function(String) f,
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
      onChanged: f,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}

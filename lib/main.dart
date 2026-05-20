import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(
    MaterialApp(
      home: const Home(title: 'Conversor de Moedas'),
      theme: ThemeData(hintColor: Colors.green, primaryColor: Colors.white),
    ),
  );
}

Future<Map> getData() async {
  String formato = kIsWeb ? 'json-cors' : 'json';

  var url = Uri.parse(
    'https://api.hgbrasil.com/finance?format=$formato&key=878111f3',
  );

  http.Response response = await http.get(url);

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 249, 250),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 68, 236, 27),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Aguarde...",
                  style: TextStyle(
                    color: Color.fromARGB(255, 43, 235, 13),
                    fontSize: 30.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );

            default:
              if (snapshot.hasError) {
                String? erro = snapshot.error.toString();

                return Center(
                  child: Text(
                    "Ops, houve uma falha ao buscar os dados : $erro",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 32, 245, 32),
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        Icons.attach_money,
                        size: 180.0,
                        color: Color.fromARGB(255, 21, 240, 21),
                      ),
                      campoTexto("Reais", "R\$ ", realController, _realChanged),
                      const Divider(),
                      campoTexto("Euros", "€ ", euroController, _euroChanged),
                      const Divider(),
                      campoTexto(
                        "Dólares",
                        "US\$ ",
                        dolarController,
                        _dolarChanged,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
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
        labelStyle: const TextStyle(color: Color.fromARGB(255, 21, 22, 21)),
        border: const OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: const TextStyle(
        color: Color.fromARGB(255, 27, 211, 27),
        fontSize: 25.0,
      ),
      onChanged: (value) => {f!(value)},
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}

import 'package:flutter/material.dart';

import 'cotacao.dart';
import 'historico.dart';
import 'login.dart';
import 'principal.dart';
import 'transferencia.dart';

void main() {
  runApp(const BancoDigitalApp());
}

class BancoDigitalApp extends StatelessWidget {
  const BancoDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(hintColor: Colors.green, primaryColor: Colors.white),
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/principal': (context) => const Principal(),
        '/cotacao': (context) => const Cotacao(),
        '/transferencia': (context) => const Transferencia(),
        '/historico': (context) => const Historico(),
      },
    );
  }
}

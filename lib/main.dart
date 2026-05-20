import 'package:flutter/material.dart';

import 'cotacao.dart';
import 'historico.dart';
import 'login.dart';
import 'principal.dart';
import 'splash.dart';
import 'transferencia.dart';

void main() {
  runApp(const BancoDigitalApp());
}

class BancoDigitalApp extends StatelessWidget {
  const BancoDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplex Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(hintColor: Colors.green, primaryColor: Colors.white),
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/login': (context) => const Login(),
        '/principal': (context) => const Principal(),
        '/cotacao': (context) => const Cotacao(),
        '/transferencia': (context) => const Transferencia(),
        '/historico': (context) => const Historico(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cotacao.dart';
import 'historico.dart';
import 'login.dart';
import 'principal.dart';
import 'splash.dart';
import 'transferencia.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF143D36),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFFEAF3F0),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BancoDigitalApp());
}

class BancoDigitalApp extends StatelessWidget {
  const BancoDigitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apex Bank',
      debugShowCheckedModeBanner: false,
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

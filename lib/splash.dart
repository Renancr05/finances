import 'dart:async';

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double opacidade = 0.0;
  double escala = 0.85;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        opacidade = 1.0;
        escala = 1.0;
      });
    });

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3F0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16.0,
              16.0,
              16.0,
              MediaQuery.of(context).padding.bottom + 16.0,
            ),
            child: AnimatedOpacity(
              opacity: opacidade,
              duration: const Duration(milliseconds: 900),
              child: AnimatedScale(
                scale: escala,
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutBack,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_apex.png',
                      width: (w * 0.45).clamp(160.0, 260.0),
                    ),

                    const SizedBox(height: 40),

                    const SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Color(0xFF143D36),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

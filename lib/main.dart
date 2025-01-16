import 'package:flutter/material.dart';
import 'package:onecontratos/pages/Home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Contratos',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      home: const PageHome(),
    );
  }
}

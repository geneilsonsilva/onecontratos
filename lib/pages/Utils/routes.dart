import 'package:flutter/material.dart';
import 'package:onecontratos/pages/Home/home.dart';
import 'package:onecontratos/pages/widgets/emitir_contratos.dart'; 

class AppRoutes {
  static const String home = '/';
  static const String emitirContratos = '/contratos';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const PageHome(),
        );
      case emitirContratos:
        return MaterialPageRoute(
          builder: (context) => const EmitirContratos(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const PageHome(),
        );
    }
  }
}

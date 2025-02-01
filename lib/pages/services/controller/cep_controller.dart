import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onecontratos/pages/services/model/cep_model.dart';

class CepController {
  final TextEditingController cepController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController municipioController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  String removerFormatacaoCep(String cep) {
    return cep.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Future<void> buscarCep() async {
  //   final cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
  //   if (cep.length != 8) {
  //     return;
  //   }

  //   final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
  //   final response = await http.get(url);
  //   debugPrint('Buscando na API: $url');
  //   debugPrint('Cep: $cep');

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final cepData = CepModel.fromJson(data);

  //     ruaController.text = cepData.logradouro;
  //     bairroController.text = cepData.bairro;
  //     municipioController.text = cepData.localidade;
  //     estadoController.text = cepData.uf;
  //   }
  // }

  Future<void> buscarCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    debugPrint('Buscando na API: $url');
    debugPrint('Cep: $cep');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cepData = CepModel.fromJson(data);

      ruaController.text = cepData.logradouro;
      bairroController.text = cepData.bairro;
      municipioController.text = cepData.localidade;
      estadoController.text = cepData.estado;
      ufController.text = cepData.uf;
    }
  }
}

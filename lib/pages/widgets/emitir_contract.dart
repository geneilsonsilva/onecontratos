import 'dart:async';
import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onecontratos/pages/Home/home.dart';
import 'package:onecontratos/pages/Utils/colors.dart';
import 'package:onecontratos/pages/Utils/dropdown.dart';
import 'package:onecontratos/pages/Utils/text.dart';
import 'package:onecontratos/pages/Utils/textformfield.dart';
import 'package:onecontratos/pages/services/controller/cep_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EmitirContratos extends StatefulWidget {
  const EmitirContratos({super.key});

  @override
  _EmitirContratosState createState() => _EmitirContratosState();
}

class _EmitirContratosState extends State<EmitirContratos> {
  int? numeroDeSocios;
  List<Map<String, String>> socios = [];
  int indexAtual = 0;
  int campoAtual = 0;
  bool exibirFormulario = false;
  final _cepController = CepController();

  // Listas de controladores para cada sócio
  List<TextEditingController> cepControllers = [];
  List<TextEditingController> ruaControllers = [];
  List<TextEditingController> numeroControllers = [];
  List<TextEditingController> bairroControllers = [];
  List<TextEditingController> municipioControllers = [];
  List<TextEditingController> estadoControllers = [];
  List<TextEditingController> ufControllers = [];

  @override
  void initState() {
    super.initState();

    if (numeroDeSocios != null) {
      // 🔥 Garante que não seja nulo antes de usar "!"
      for (int i = 0; i < numeroDeSocios!; i++) {
        cepControllers.add(TextEditingController());
        ruaControllers.add(TextEditingController());
        numeroControllers.add(TextEditingController());
        bairroControllers.add(TextEditingController());
        municipioControllers.add(TextEditingController());
        estadoControllers.add(TextEditingController());
        ufControllers.add(TextEditingController());
      }
    }
  }

  @override
  void dispose() {
    for (var controller in [
      ...cepControllers,
      ...ruaControllers,
      ...numeroControllers,
      ...bairroControllers,
      ...municipioControllers,
      ...estadoControllers,
      ...ufControllers,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  // String removerFormatacaoCep(String cep) {
  //   return cep.replaceAll(RegExp(r'[^0-9]'), '');
  // }

  Future<void> buscarCep(int index) async {
    String cep = removerFormatacaoCep(cepControllers[index].text);
    if (cep.length != 8) return;

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        ruaControllers[index].text = data['logradouro'] ?? '';
        bairroControllers[index].text = data['bairro'] ?? '';
        numeroControllers[index].text = data['unidade'] ?? '';
        municipioControllers[index].text = data['localidade'] ?? '';
        estadoControllers[index].text = data['estado'] ?? '';
        ufControllers[index].text = data['estado'] ?? '';
      });
    }
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _nacionalidadeController =
      TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final TextEditingController _profissaoController = TextEditingController();
  final TextEditingController _numeroDocController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _naturalController = TextEditingController();

  final TextEditingController _atividadeEconomicaController =
      TextEditingController();

  // |||||||||||||||||||||| FORMULARIO SOCIOS ||||||||||||||||||||||
  List<TextEditingController> nomeControllers = [];
  List<TextEditingController> nacionalidadeControllers = [];
  List<TextEditingController> nascimentoControllers = [];
  List<TextEditingController> rgControllers = [];
  List<TextEditingController> cpfControllers = [];
  List<TextEditingController> numeroDocumentoControllers = [];
  List<TextEditingController> profissaoControllers = [];
  List<String?> sexoControllers = [];
  List<String?> naturezaSocioControllers = [];
  List<String?> estadoCivilSocioControllers = [];
  List<String?> tipoDocControllers = [];

  String? tipoEstadoCivil;
  String? tipoPessoa;
  String? tipoSexo;
  String? tipoDocumento;

  String tipoCliente = 'PF';

  String removerFormatacaoCep(String cep) {
    return cep.replaceAll(RegExp(r'[^0-9]'), '');
  }

  void _onSexoChanged(String? value) {
    setState(() {
      tipoSexo = value;
    });
  }

  void _estadoCivil(String? value) {
    setState(() {
      tipoEstadoCivil = value;
    });
  }

  void _pessoa(String? value) {
    setState(() {
      tipoPessoa = value;
    });
  }

  void _sexo(String? value) {
    setState(() {
      tipoSexo = value;
    });
  }

  void _documento(String? value) {
    setState(() {
      tipoDocumento = value;
    });
    if (tipoDocumento == '') {}
  }

  String _getEstadoCivilDescricao() {
    if (tipoEstadoCivil == 'casado') {
      return 'casado, sob comunhão parcial de bens';
    } else {
      return tipoEstadoCivil ?? '';
    }
  }

  String getPessoa() {
    if (tipoPessoa == 'juridica') {
      return 'a pessoa juridica ';
    } else {
      return tipoPessoa ?? '';
    }
  }

  String getSexo() {
    return tipoSexo ?? '';
  }

  String getDocumento() {
    return tipoDocumento ?? '';
  }

  // Função para atualizar o número de sócios
  void _atualizarNumeroDeSocios(int quantidade) {
    setState(() {
      numeroDeSocios = quantidade;
      exibirFormulario = true;

      // Ajustar o tamanho das listas de controladores
      nomeControllers =
          List.generate(quantidade, (index) => TextEditingController());
      nacionalidadeControllers =
          List.generate(quantidade, (index) => TextEditingController());
      nascimentoControllers =
          List.generate(quantidade, (index) => TextEditingController());
      rgControllers =
          List.generate(quantidade, (index) => TextEditingController());
      cpfControllers =
          List.generate(quantidade, (index) => TextEditingController());
      numeroDocumentoControllers =
          List.generate(quantidade, (index) => TextEditingController());
      profissaoControllers =
          List.generate(quantidade, (index) => TextEditingController());
      sexoControllers = List.generate(quantidade, (index) => null);

      List.generate(quantidade, (index) => TextEditingController());
      naturezaSocioControllers = List.generate(quantidade, (index) => null);
      List.generate(quantidade, (index) => TextEditingController());
      estadoCivilSocioControllers = List.generate(quantidade, (index) => null);
      List.generate(quantidade, (index) => TextEditingController());
      tipoDocControllers = List.generate(quantidade, (index) => null);

      cepControllers =
          List.generate(quantidade, (_) => TextEditingController());
      ruaControllers =
          List.generate(quantidade, (_) => TextEditingController());
      numeroControllers =
          List.generate(quantidade, (_) => TextEditingController());
      bairroControllers =
          List.generate(quantidade, (_) => TextEditingController());
      municipioControllers =
          List.generate(quantidade, (_) => TextEditingController());
      estadoControllers =
          List.generate(quantidade, (_) => TextEditingController());
    });
  }

  List<Widget> _buildCamposPJ() {
    return [
      _buildTextFieldCNPJ(''),
      // _buildTextField('Exemplo'),
      // _buildTextField('(12) 93456-7891'),
      // _buildTextField('exemplo@exemplo.com'),
      // _buildTextField('R\$ 0,00'),
    ];
  }

  List<Widget> _buildCamposPF() {
    return [
      _buildTextFieldCPF(''),
      // _buildTextField('Exemplo'),
      // _buildTextField('(12) 93456-7891'),
      // _buildTextField('exemplo@exemplo.com'),
      // _buildTextField('R\$ 0,00'),
      // _buildTextField('dd/mm/aaaa', isDate: true),
    ];
  }

  Widget _buildTextFieldCPF(String hint, {bool isDate = false}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  'Nome completo *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: textFormField("Exemplo"),
                  keyboardType: TextInputType.text,
                  controller: _nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                customText(
                  'Nacionalidade *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: textFormField("brasileiro"),
                  keyboardType: TextInputType.text,
                  controller: _nacionalidadeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                customText(
                  'Sexo *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomDropdown(
                  value: tipoSexo,
                  items: const [
                    DropdownMenuItem(
                        value: "masculino", child: Text("Masculino")),
                    DropdownMenuItem(
                        value: "feminino", child: Text("Feminino")),
                  ],
                  onChanged: _onSexoChanged,
                  hintText: "Selecione o Sexo",
                  fillColor: const Color(0xFFF1F4FF),
                  borderColor: Colors.grey,
                  focusedBorderColor: Colors.blue,
                  errorBorderColor: Colors.red,
                  borderRadius: 8.0,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  'CPF *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: textFormField("123.456.789-10"),
                  keyboardType: TextInputType.text,
                  controller: _cpfController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                ),
                const SizedBox(height: 10),
                customText(
                  'Naturalidade *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: textFormField("Digite o CEP"),
                  keyboardType: TextInputType.text,
                  controller: _cepController.cepController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                ),
                const SizedBox(height: 10),
                customText(
                  'Data nascimento *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: textFormField("01/01/2000"),
                  keyboardType: TextInputType.text,
                  controller: _nascimentoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    DataInputFormatter(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldCNPJ(String hint, {bool isDate = false}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  'Nome fantasia *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: textFormField("Exemplo"),
                  keyboardType: TextInputType.text,
                  controller: _nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                //
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 25,
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  'CNPJ *',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: textFormField("12.345.678/0001-91"),
                  keyboardType: TextInputType.text,
                  controller: _cpfController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CnpjInputFormatter(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'CONTRATO DE CONSTITUIÇÃO DA SOCIEDADE EMPRESÁRIA LIMITADA',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'ACCOUNTING SOLUTIONS LTDA',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '${_nomeController.text.toUpperCase().trim()}, ',
                    // text: '${socios[indexAtual]["nome"]}'.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text:
                        '${_nacionalidadeController.text.trim()}, ${_getEstadoCivilDescricao()}, ${_profissaoController.text.trim()}, natural de ${_naturalController.text.trim()}, nascido em ${_nascimentoController.text.trim()}, portador da Cédula de Identidade ',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.TextSpan(
                    text: 'RG sob o n.º ${_numeroDocController.text.trim()}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text: ', e inscrito no ',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.TextSpan(
                    text: ' CPF. Sob o n.o ${_cpfController.text.trim()}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.TextSpan(
                    text:
                        ', residente e domiciliado na Rua ${_cepController.ruaController.text}, n. ${_cepController.numeroController.text}, ${_cepController.bairroController.text}, Município de ${_cepController.municipioController.text}, Estado do ${_cepController.estadoController.text}, CEP ${_cepController.cepController.text};',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            ...List.generate(
                numeroDeSocios!, (index) => _buildSocioSection(index)),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA PRIMEIRA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text: 'A sociedade girará sob o nome empresarial ',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.TextSpan(
                    text: 'ACCOUNTING SOLUTIONS LTDA, ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'e terá sede na Rua Gonçalves Dias, n.º 565, Bairro Centro, Anxeo I, Andar 1, Sala 4, Município de Imperatriz, Estado do Maranhão, CEP: 65.900-450;',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA SEGUNDA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text: 'O capital social será de',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.TextSpan(
                    text: ' R\$ 20.000,00 (Vinte Mil Reais), ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text: 'dividido em ',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.TextSpan(
                    text: '(Vinte Mil) ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text: 'quotas de valor nominal R\$ ',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.TextSpan(
                    text: '1,00 (um real) ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'cada uma, integralizadas neste ato em moeda corrente do País, ficando assim distribuídos pelos sócios:',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'SÓCIO',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Quotas',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '%',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'VALOR',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'GILLEZ NEPONUCENO MENDES',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'A - Capital Social Integralizado',
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Total de sua participação:',
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('18.000',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('90',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('18.000,00',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'SÓCIO',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'A - Capital Social Integralizado',
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Total de sua participação:',
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('', textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'MARCOS ANTONIO SILVA E SILVA',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '2.000',
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('10',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('2.000,00',
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'TOTAL',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('20.000',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('100',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('20.000,00',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA TERCEIRA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text: 'O objeto será:',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.Bullet(
              text:
                  '82.11-3/00 - Serviços combinados de escritório e apoio administrativo',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA QUARTA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'A sociedade iniciará suas atividades na data da aprovação deste contrato e seu prazo de duração é indeterminado. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: '(art. 997, II, CC/2002)',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
          ],
        ),
      ),
    );

    /////// 2 página \\\\\\\\

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'CONTRATO DE CONSTITUIÇÃO DA SOCIEDADE EMPRESÁRIA LIMITADA',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'ACCOUNTING SOLUTIONS LTDA',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA QUINTA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'As quotas são indivisíveis e não poderão ser cedidas ou transferidas a terceiros sem o consentimento do outro sócio, a quem fica assegurado, em igualdade de condições e preço direito de preferência para a sua aquisição se postas à venda, formalizando, se realizada a cessão delas, a alteração contratual pertinente. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: '(art.1.056, art. 1.057, CC/2002)',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA SEXTA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'A responsabilidade de cada sócio é restrita ao valor de suas quotas, mas todos respondem solidariamente pela integralização do capital social. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: '(art. 1.052, CC/2002)',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA SETIMA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'A sociedade através de seus sócios liberam a entrada de administradores não sócios no seu quadro de administração;',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA OITAVA- ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text: 'A administração da sociedade caberá ao sócio o Sr. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: 'GILLEZ NEPONUCENO MENDES, ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'qualificado no preâmbulo deste instrumento, com os poderes e atribuições de administradora autorizado o uso do nome empresarial podendo assinar em conjunto ou isoladamente, em todos os Órgãos Federal, Estadual e Municipal, abrir e movimentar contas correntes em todos os bancos públicos e privados, vedado, no entanto, em atividades estranhas ao interesse social ou assumir obrigações seja em favor de qualquer dos quotistas ou de terceiros, bem como onerar ou alienar bens imóveis da sociedade, sem autorização do outro sócio. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: '(artigos 997, Vl; 1.013. 1.015, 1064, CC/2002).',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA NONA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'Ao término da cada exercício social, em 31 de dezembro, o administrador prestará contas justificadas de sua administração, procedendo à elaboração do inventário, do balanço patrimonial e do balanço de resultado econômico, cabendo aos sócios, na proporção de suas quotas, os lucros ou perdas apurados. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: '(art. 1.065, CC/2002)',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA DECIMA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'Nos quatros meses seguintes ao término do exercício social, os sócios deliberarão sobre as contas e designarão administrador(es) quando for o caso. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: '(arts. 1.071 e 1.072, § 2º e art. 1.078, CC/2002)',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA DECIMA PRIMEIRA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'A sociedade poderá a qualquer tempo, abrir ou fechar filial ou outra dependência, mediante alteração contratual assinada por todos os sócios.',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA DECIMA SEGUNDA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'Os sócios poderão de comum acordo, fixar uma retirada mensal, a título de "pro labore", observadas as disposições regulamentares pertinentes.',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
          ],
        ),
      ),
    );

    /////// 3 página \\\\\\\\

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'CONTRATO DE CONSTITUIÇÃO DA SOCIEDADE EMPRESÁRIA LIMITADA',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'ACCOUNTING SOLUTIONS LTDA',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA DECIMA TERCEIRA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'Falecendo ou interditado qualquer sócio, a sociedade continuará suas atividades com os herdeiros, sucessores e o incapaz. Não sendo possível ou inexistindo interesse destes ou do(s) sócio(s) remanescente(s), o valor de seus haveres será apurado e liquidado com base na situação patrimonial da sociedade, verificada em balanço especialmente levantado.',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'Parágrafo único - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'O mesmo procedimento será adotado em outros casos em que a sociedade se resolva em relação a seu sócio. (art. 1.028 e art. 1.031, CC/2002)',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  // pw.TextSpan(
                  //   text: '(art. 1.052, CC/2002)',
                  //   style: pw.TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: pw.FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: 'CLAUSULA DECIMA QUARTA - ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'O administrador declara, sob as penas da lei, de que não esta impedido de exercer a administração da sociedade, por lei especial, ou em virtude de condenação criminal, ou por se encontrar sob os efeitos dela, a pena que vede, ainda que temporariamente, o acesso a cargos públicos; ou por crime falimentar, de prevaricação, peita ou suborno, concussão, peculato, ou contra a economia popular, contra o sistema financeiro nacional, contra normas de ocorrência, contra as relações de consumo, fé pública, ou a propriedade. ',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.TextSpan(
                    text: '(art. 1.011, § 1o, CC/2002)',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text:
                        'CLAUSULA DECIMA QUINTA - Fica eleito o foro de Imperatriz - MA, ',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  const pw.TextSpan(
                    text:
                        'para o exercício e o cumprimento dos direitos e obrigações resultantes deste contrato.',
                    style: pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'E por estarem assim justos e contratados assinam o presente instrumento.',
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                'Imperatriz - MA, 28 de abril de 2021.',
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 50),
            pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    '________________________________________',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.Text(
                    'GILLEZ NEPONUCENO MENDES',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Sócio Administrador',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 50),
            pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    '________________________________________',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  pw.Text(
                    'MARCOS ANTONIO SILVA E SILVA',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Sócio',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // RINCH TEXT PRIMEIRA PAGINA
  pw.Widget _buildSocioSection(int index) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: nomeControllers[index].text.toUpperCase().trim(),
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.TextSpan(
                text:
                    ', ${nacionalidadeControllers[index].text.trim()}, natural de ${nacionalidadeControllers[index].text.trim()}, ${estadoCivilSocioControllers[index]}, nascido em ${nascimentoControllers[index].text.trim()}, empresário, portador da Carteira Nacional de Habilitação CNH',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.TextSpan(
                text:
                    ' sob n.o ${numeroDocumentoControllers[index].text.trim()}',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              const pw.TextSpan(
                text: ', e inscrito no ',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.TextSpan(
                text: ' CPF. Sob o n.o ${cpfControllers[index].text.trim()}, ',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              const pw.TextSpan(
                text:
                    'residente e domiciliado na Rua Maranhão, n.o 933, Bairro Nova Imperatriz, Município de Imperatriz, Estado do Maranhão, CEP 65.907-110, resolvem de comum acordo constituir uma sociedade empresária limitada, conforme clausulas e condições a seguir:',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          textAlign: pw.TextAlign.justify,
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PageHome(),
              ),
            );
          },
          iconSize: 20,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Preenchimento do Contrato',
          style: GoogleFonts.poppins(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // numero de sócios
                  Center(
                    child: SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: DropdownButtonFormField<int>(
                          value: numeroDeSocios,
                          hint: Text(
                            "Selecione o número de sócios",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                          items: List.generate(
                            3,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text("${index + 1} Sócios"),
                            ),
                          ),
                          onChanged: (novoNumero) {
                            if (novoNumero != null) {
                              _atualizarNumeroDeSocios(novoNumero);
                              setState(() {
                                exibirFormulario = true;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            label: const Text("Sócios"),
                            fillColor: const Color(0xFFF1F4FF).withOpacity(0.9),
                            filled: true,
                            labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFF626262)),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF262c40), width: 2.0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF262c40), width: 2.0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF262c40), width: 2.0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF262c40), width: 2.0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF262c40), width: 2.0),
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      if (exibirFormulario)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Alinha o conteúdo ao topo
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 32), // Ajuste do padding lateral
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Alinha o texto à esquerda
                                children: [
                                  Text(
                                    'Dados do sócio',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Preencha as informações',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 200,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('Pessoa Física PF'),
                                          value: 'PF',
                                          groupValue: tipoCliente,
                                          onChanged: (value) {
                                            setState(
                                              () {
                                                tipoCliente = value!;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title:
                                              const Text('Pessoa Jurídica PJ'),
                                          value: 'PJ',
                                          groupValue: tipoCliente,
                                          onChanged: (value) {
                                            setState(() {
                                              tipoCliente = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Form(
                                    child: Column(
                                      children: tipoCliente == 'PJ'
                                          ? _buildCamposPJ()
                                          : _buildCamposPF(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  Divider(thickness: 1, color: Colors.grey[300]),
                  // Row(
                  //   children: [
                  //     if (exibirFormulario)
                  //       Text(
                  //         "Sócio 1",
                  //         style: GoogleFonts.poppins(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.w700,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 300,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: DropdownButtonFormField<String>(
                  //           value: tipoPessoa,
                  //           items: const [
                  //             DropdownMenuItem(
                  //               value: "fisica",
                  //               child: Text("Pessoa Física"),
                  //             ),
                  //             DropdownMenuItem(
                  //               value: "juridica",
                  //               child: Text("Pessoa Jurídica"),
                  //             ),
                  //           ],
                  //           onChanged: _pessoa,
                  //           decoration: InputDecoration(
                  //             label: const Text("Qual é a natureza"),
                  //             fillColor:
                  //                 const Color(0xFFF1F4FF).withOpacity(0.9),
                  //             filled: true,
                  //             labelStyle: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 16,
                  //                 color: const Color(0xFF626262)),
                  //             isDense: true,
                  //             border: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedErrorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             errorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // // sexo
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: DropdownButtonFormField<String>(
                  //           value: tipoSexo,
                  //           items: const [
                  //             DropdownMenuItem(
                  //               value: "masculino",
                  //               child: Text("Masculino"),
                  //             ),
                  //             DropdownMenuItem(
                  //               value: "feminino",
                  //               child: Text("Feminito"),
                  //             ),
                  //           ],
                  //           onChanged: _sexo,
                  //           decoration: InputDecoration(
                  //             label: const Text("Sexo"),
                  //             fillColor:
                  //                 const Color(0xFFF1F4FF).withOpacity(0.9),
                  //             filled: true,
                  //             labelStyle: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 16,
                  //                 color: const Color(0xFF626262)),
                  //             isDense: true,
                  //             border: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedErrorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             errorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  // Expanded(
                  //   flex: 1,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 15),
                  //     child: TextFormField(
                  //       decoration: textFormField("Nome"),
                  //       keyboardType: TextInputType.text,
                  //       controller: _nomeController,
                  //       validator: (value) {
                  //         if (value == null || value.isEmpty) {
                  //           return "Campo obrigatório.";
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   ),
                  // ),
                  //     const SizedBox(width: 25),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Nacionalidade"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _nacionalidadeController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     // estado civil
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: DropdownButtonFormField<String>(
                  //           value: tipoEstadoCivil,
                  //           items: const [
                  //             DropdownMenuItem(
                  //                 value: "solteiro", child: Text("Solteiro")),
                  //             DropdownMenuItem(
                  //                 value: "casado", child: Text("Casado")),
                  //             DropdownMenuItem(
                  //                 value: "divorciado",
                  //                 child: Text("Divorciado")),
                  //             DropdownMenuItem(
                  //                 value: "viuvo", child: Text("Viúvo")),
                  //           ],
                  //           onChanged: _estadoCivil,
                  //           decoration: InputDecoration(
                  //             label: const Text("Estado Cívil"),
                  //             fillColor:
                  //                 const Color(0xFFF1F4FF).withOpacity(0.9),
                  //             filled: true,
                  //             labelStyle: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 16,
                  //                 color: const Color(0xFF626262)),
                  //             isDense: true,
                  //             border: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedErrorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             errorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),

                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Naturalidade"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _naturalController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Data Nascimento"),
                  //           keyboardType: TextInputType.number,
                  //           controller: _nascimentoController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //           inputFormatters: [
                  //             FilteringTextInputFormatter.digitsOnly,
                  //             DataInputFormatter(),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // // Documento de identificação:
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Profissão"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _profissaoController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: DropdownButtonFormField<String>(
                  //           value: tipoDocumento,
                  //           items: const [
                  //             DropdownMenuItem(
                  //               value: "identidade",
                  //               child: Text("Carteira de Identidade"),
                  //             ),
                  //             DropdownMenuItem(
                  //               value: "funcional",
                  //               child: Text("Identidade Funcional"),
                  //             ),
                  //             DropdownMenuItem(
                  //               value: "cnh",
                  //               child: Text("Carteira de Motorista (CNH)"),
                  //             ),
                  //             DropdownMenuItem(
                  //               value: "passaporte",
                  //               child: Text("Passaporte"),
                  //             ),
                  //           ],
                  //           onChanged: _documento,
                  //           decoration: InputDecoration(
                  //             label: const Text("Documento de Identificação"),
                  //             fillColor:
                  //                 const Color(0xFFF1F4FF).withOpacity(0.9),
                  //             filled: true,
                  //             labelStyle: GoogleFonts.poppins(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 16,
                  //                 color: const Color(0xFF626262)),
                  //             isDense: true,
                  //             border: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             enabledBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             focusedErrorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //             errorBorder: OutlineInputBorder(
                  //               borderSide: const BorderSide(
                  //                   color: Color(0xFF262c40), width: 2.0),
                  //               borderRadius: BorderRadius.circular(11),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Número Documento"),
                  //           keyboardType: TextInputType.name,
                  //           controller: _numeroDocController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("CPF"),
                  //           keyboardType: TextInputType.number,
                  //           controller: _cpfController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //           inputFormatters: [
                  //             FilteringTextInputFormatter.digitsOnly,
                  //             CpfInputFormatter(),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("CEP"),
                  //           keyboardType: TextInputType.number,
                  //           controller: _cepController.cepController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //           inputFormatters: [
                  //             FilteringTextInputFormatter.digitsOnly,
                  //             CepInputFormatter()
                  //           ],
                  //           onChanged: (value) {
                  //             final cepLimpo = removerFormatacaoCep(value);
                  //             if (cepLimpo.length == 8) {
                  //               _cepController.buscarCep(cepLimpo);
                  //             }
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Rua"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _cepController.ruaController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 200,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("N°"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _cepController.numeroController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     SizedBox(
                  //       width: 250,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Bairro"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _cepController.bairroController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     SizedBox(
                  //       width: 250,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Municipio"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _cepController.municipioController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     SizedBox(
                  //       width: 250,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Estado"),
                  //           keyboardType: TextInputType.text,
                  //           controller: _cepController.estadoController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // // |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                  // // |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                  // // |||||||||||||||||||||||||||||||||||| FORMULARIO SOCIOS ||||||||||||||||||||||||||||||||||||||||
                  // // |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                  // // |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                  // Column(
                  //   children: List.generate(
                  //     numeroDeSocios ??
                  //         0, // Gera a quantidade de campos conforme o número de sócios
                  //     (index) => Padding(
                  //       padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //       child: Column(
                  //         children: [
                  //           const SizedBox(height: 5),
                  //           const Divider(thickness: 1, color: Colors.grey),
                  //           const SizedBox(height: 15),
                  //           Row(
                  //             children: [
                  //               Text(
                  //                 "Sócio ${index + 2}",
                  //                 style: GoogleFonts.poppins(
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.w700,
                  //                   color: Colors.black,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),

                  //           const SizedBox(height: 5),

                  //           Row(
                  //             children: [
                  //               SizedBox(
                  //                 width: 300,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: DropdownButtonFormField<String>(
                  //                     value: naturezaSocioControllers[index],
                  //                     items: const [
                  //                       DropdownMenuItem(
                  //                         value: "fisica",
                  //                         child: Text("Pessoa Física"),
                  //                       ),
                  //                       DropdownMenuItem(
                  //                         value: "juridica",
                  //                         child: Text("Pessoa Jurídica"),
                  //                       ),
                  //                     ],
                  //                     onChanged: (String? newValue) {
                  //                       if (newValue != null) {
                  //                         setState(() {
                  //                           naturezaSocioControllers[index] =
                  //                               newValue;
                  //                         });
                  //                       }
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       label: const Text("Qual é a natureza"),
                  //                       fillColor: const Color(0xFFF1F4FF)
                  //                           .withOpacity(0.9),
                  //                       filled: true,
                  //                       labelStyle: GoogleFonts.poppins(
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 16,
                  //                           color: const Color(0xFF626262)),
                  //                       isDense: true,
                  //                       border: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       enabledBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedErrorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       errorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),

                  //           // sexo
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: DropdownButtonFormField<String>(
                  //                     value: sexoControllers[index],
                  //                     items: const [
                  //                       DropdownMenuItem(
                  //                         value: "masculino",
                  //                         child: Text("Masculino"),
                  //                       ),
                  //                       DropdownMenuItem(
                  //                         value: "feminino",
                  //                         child: Text("Feminino"),
                  //                       ),
                  //                     ],
                  //                     onChanged: (String? newValue) {
                  //                       if (newValue != null) {
                  //                         setState(() {
                  //                           sexoControllers[index] = newValue;
                  //                         });
                  //                       }
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       label: const Text("Sexo"),
                  //                       fillColor: const Color(0xFFF1F4FF)
                  //                           .withOpacity(0.9),
                  //                       filled: true,
                  //                       labelStyle: GoogleFonts.poppins(
                  //                         fontWeight: FontWeight.w500,
                  //                         fontSize: 16,
                  //                         color: const Color(0xFF626262),
                  //                       ),
                  //                       isDense: true,
                  //                       border: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       enabledBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedErrorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       errorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("Nome"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller: nomeControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration:
                  //                         textFormField("Nacionalidade"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller:
                  //                         nacionalidadeControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               // estado civil
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: DropdownButtonFormField<String>(
                  //                     value: estadoCivilSocioControllers[index],
                  //                     items: const [
                  //                       DropdownMenuItem(
                  //                           value: "solteiro",
                  //                           child: Text("Solteiro")),
                  //                       DropdownMenuItem(
                  //                           value: "casado",
                  //                           child: Text("Casado")),
                  //                       DropdownMenuItem(
                  //                           value: "divorciado",
                  //                           child: Text("Divorciado")),
                  //                       DropdownMenuItem(
                  //                           value: "viuvo",
                  //                           child: Text("Viúvo")),
                  //                     ],
                  //                     onChanged: (String? newValue) {
                  //                       if (newValue != null) {
                  //                         setState(
                  //                           () {
                  //                             estadoCivilSocioControllers[
                  //                                 index] = newValue;
                  //                           },
                  //                         );
                  //                       }
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       label: const Text("Estado Cívil"),
                  //                       fillColor: const Color(0xFFF1F4FF)
                  //                           .withOpacity(0.9),
                  //                       filled: true,
                  //                       labelStyle: GoogleFonts.poppins(
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 16,
                  //                           color: const Color(0xFF626262)),
                  //                       isDense: true,
                  //                       border: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       enabledBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedErrorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       errorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),

                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("Naturalidade"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller:
                  //                         nacionalidadeControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration:
                  //                         textFormField("Data Nascimento"),
                  //                     keyboardType: TextInputType.number,
                  //                     controller: nascimentoControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       DataInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),

                  //           // Documento de identificação:
                  //           Row(
                  //             children: [
                  //               // Documento de identificação:
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("Profissão"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller: profissaoControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CpfInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: DropdownButtonFormField<String>(
                  //                     value: tipoDocControllers[index],
                  //                     items: const [
                  //                       DropdownMenuItem(
                  //                         value: "Identidade",
                  //                         child: Text("Carteira de Identidade"),
                  //                       ),
                  //                       DropdownMenuItem(
                  //                         value: "funcional",
                  //                         child: Text("Identidade Funcional"),
                  //                       ),
                  //                       DropdownMenuItem(
                  //                         value: "CNH",
                  //                         child: Text(
                  //                             "Carteira de Motorista (CNH)"),
                  //                       ),
                  //                       DropdownMenuItem(
                  //                         value: "Passaporte",
                  //                         child: Text("Passaporte"),
                  //                       ),
                  //                     ],
                  //                     onChanged: (String? newValue) {
                  //                       if (newValue != null) {
                  //                         setState(
                  //                           () {
                  //                             tipoDocControllers[index] =
                  //                                 newValue;
                  //                           },
                  //                         );
                  //                       }
                  //                     },
                  //                     decoration: InputDecoration(
                  //                       label: const Text(
                  //                           "Documento de Identificação"),
                  //                       fillColor: const Color(0xFFF1F4FF)
                  //                           .withOpacity(0.9),
                  //                       filled: true,
                  //                       labelStyle: GoogleFonts.poppins(
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 16,
                  //                           color: const Color(0xFF626262)),
                  //                       isDense: true,
                  //                       border: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       enabledBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       focusedErrorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                       errorBorder: OutlineInputBorder(
                  //                         borderSide: const BorderSide(
                  //                             color: Color(0xFF262c40),
                  //                             width: 2.0),
                  //                         borderRadius:
                  //                             BorderRadius.circular(11),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration:
                  //                         textFormField("Número Documento"),
                  //                     keyboardType: TextInputType.name,
                  //                     controller:
                  //                         numeroDocumentoControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CpfInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("CPF"),
                  //                     keyboardType: TextInputType.number,
                  //                     controller: cpfControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CpfInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("CEP"),
                  //                     keyboardType: TextInputType.number,
                  //                     controller: cepControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CepInputFormatter(),
                  //                     ],
                  //                     onChanged: (value) {
                  //                       if (removerFormatacaoCep(value)
                  //                               .length ==
                  //                           8) {
                  //                         buscarCep(index);
                  //                       }
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               Expanded(
                  //                 flex: 1,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("Rua"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller: ruaControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CpfInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),

                  //           Row(
                  //             children: [
                  //               // Documento de identificação:
                  //               SizedBox(
                  //                 width: 200,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("N°"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller: numeroControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CpfInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),

                  //               const SizedBox(width: 25),
                  //               SizedBox(
                  //                 width: 250,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("Bairro"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller: bairroControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CpfInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               SizedBox(
                  //                 width: 250,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("Municipio"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller: municipioControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 25),
                  //               SizedBox(
                  //                 width: 250,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.only(bottom: 15),
                  //                   child: TextFormField(
                  //                     decoration: textFormField("Estado"),
                  //                     keyboardType: TextInputType.text,
                  //                     controller: estadoControllers[index],
                  //                     validator: (value) {
                  //                       if (value == null || value.isEmpty) {
                  //                         return "Campo obrigatório.";
                  //                       }
                  //                       return null;
                  //                     },
                  //                     inputFormatters: [
                  //                       FilteringTextInputFormatter.digitsOnly,
                  //                       CpfInputFormatter(),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // const SizedBox(height: 5),
                  // const Divider(thickness: 1, color: Colors.grey),
                  // const SizedBox(height: 15),

                  // Row(
                  //   children: [
                  //     // atividade economica
                  //     SizedBox(
                  //       width: 500,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Atividade Economica"),
                  //           keyboardType: TextInputType.number,
                  //           // controller: _cpfController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //           inputFormatters: [
                  //             FilteringTextInputFormatter.digitsOnly,
                  //             CpfInputFormatter(),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     SizedBox(
                  //       width: 250,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("Município e Estado"),
                  //           keyboardType: TextInputType.number,
                  //           // controller: _cpfController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //           inputFormatters: [
                  //             FilteringTextInputFormatter.digitsOnly,
                  //             CpfInputFormatter(),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 25),
                  //     SizedBox(
                  //       width: 200,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(bottom: 15),
                  //         child: TextFormField(
                  //           decoration: textFormField("CEP"),
                  //           keyboardType: TextInputType.number,
                  //           // controller: _cpfController,
                  //           validator: (value) {
                  //             if (value == null || value.isEmpty) {
                  //               return "Campo obrigatório.";
                  //             }
                  //             return null;
                  //           },
                  //           inputFormatters: [
                  //             FilteringTextInputFormatter.digitsOnly,
                  //             CpfInputFormatter(),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

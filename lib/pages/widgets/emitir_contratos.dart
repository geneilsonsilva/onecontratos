import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EmitirContratos extends StatefulWidget {
  const EmitirContratos({super.key});

  @override
  _EmitirContratosState createState() => _EmitirContratosState();
}

class _EmitirContratosState extends State<EmitirContratos> {
  // Controladores para os campos
  final TextEditingController sellerController = TextEditingController();
  final TextEditingController buyerController = TextEditingController();

  void _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
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
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'GILLEZ NEPONUCENO MENDES, brasileiro, natural de Imperatriz - MA, divorciado,\nnascido em 24/02/1979, portador da Cédula de Identidade RG sob o n.º 000045844995-4\nSESP/MA, e inscrito no CPF. Sob o n.º 618.215.193-53, residente e domiciliado na Rua\nMarechal Hermes da Fonseca, n. 137, Juçara, Município de Imperatriz, Estado do\nMaranhão, CEP 65.900-575;',
              style: pw.TextStyle(fontSize: 12),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'MARCOS ANTONIO SILVA E SILVA, brasileiro, natural de Imperatriz - MA, solteiro,\nnascido em 20/11/1998, empresário, portador da Carteira Nacional de Habilitação CNH\nsob n.º 06803018837 DETRAN MA, e inscrito no CPF. Sob o n.º 071.232.353-80,\nresidente e domiciliado na Rua Maranhão, n.º 933, Bairro Nova Imperatriz, Município de\nImperatriz, Estado do Maranhão, CEP 65.907-110, resolvem de comum acordo constituir\numa sociedade empresária limitada, conforme clausulas e condições a seguir:',
              style: pw.TextStyle(fontSize: 12),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
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
                  pw.TextSpan(
                    text:
                        'A sociedade girará sob o nome empresarial ACCOUNTING SOLUTIONS LTDA, e terá sede na Rua Gonçalves Dias, n.º 565, Bairro Centro, Anxeo I, Andar 1, Sala 4, Município de Imperatriz, Estado do Maranhão, CEP: 65.900-450;',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'CLAUSULA SEGUNDA - O capital social será de R\$ 20.000,00 (Vinte Mil Reais),\ndividido em (Vinte Mil) quotas de valor nominal R\$ 1,00 (um real) cada uma,\nintegralizadas neste ato em moeda corrente do País, ficando assim distribuídos pelos\nsócios:',
              style: pw.TextStyle(fontSize: 12),
              textAlign: pw.TextAlign.justify,
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
              columnWidths: {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1),
                3: pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'SÓCIO',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text(
                        'Quotas',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '%',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
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
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text('GILLEZ NEPONUCENO MENDES'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text('18.000', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text('90', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child:
                          pw.Text('18.000,00', textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text('MARCOS ANTONIO SILVA E SILVA'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text('2.000', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text('10', textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child:
                          pw.Text('2.000,00', textAlign: pw.TextAlign.center),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'CLAUSULA TERCEIRA - O objeto será:',
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Bullet(
              text:
                  '82.11-3/00 - Serviços combinados de escritório e apoio administrativo',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'CLAUSULA QUARTA - A sociedade iniciará suas atividades na data da aprovação deste contrato e seu prazo de duração é indeterminado. (art. 997, II, CC/2002)',
              style: pw.TextStyle(fontSize: 12),
              textAlign: pw.TextAlign.justify,
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 81, 1, 1),
        foregroundColor: Colors.white,
        title: Text(
          'Preenchimento Dinâmico de Contrato',
          style: GoogleFonts.poppins(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generatePdf, // Chama a função para gerar PDF
          ),
        ],
      ),
      body: Row(
        children: [
          // Formulário do lado esquerdo
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Qual é o nome do vendedor?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: sellerController,
                    decoration:
                        const InputDecoration(labelText: 'Nome completo'),
                    onChanged: (value) {
                      setState(() {}); // Atualiza a exibição do texto
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Qual é o nome do comprador?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: buyerController,
                    decoration:
                        const InputDecoration(labelText: 'Nome completo'),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, color: Colors.grey),
          // Simulação do "PDF" do lado direito
          const Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      '''
CONTRATO DE CONSTITUIÇÃO DA SOCIEDADE EMPRESÁRIA LIMITADA
ACCOUNTING SOLUTIONS LTDA''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '''
GILLEZ NEPONUCENO MENDES, brasileiro, natural de Imperatriz - MA, divorciado,
nascido em 24/02/1979, portador da Cédula de Identidade RG sob o n.o 000045844995-4
SESP/MA, e inscrito no CPF. Sob o n.o 618.215.193-53, residente e domiciliado na Rua
Marechal Hermes da Fonseca, n. 137, Juçara, Município de Imperatriz, Estado do
Maranhão, CEP 65.900-575;
                      ''',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text('''
MARCOS ANTONIO SILVA E SILVA, brasileiro, natural de Imperatriz - MA, solteiro,
nascido em 20/11/1998, empresário, portador da Carteira Nacional de Habilitação CNH
sob n.º 06803018837 DETRAN MA, e inscrito no CPF. Sob o n.º 071.232.353-80,
residente e domiciliado na Rua Maranhão, n.º 933, Bairro Nova Imperatriz, Município de
Imperatriz, Estado do Maranhão, CEP 65.907-110, resolvem de comum acordo constituir
uma sociedade empresária limitada, conforme clausulas e condições a seguir:
'''),
                    Text('''
CLAUSULA PRIMEIRA - A sociedade girará sob o nome empresarial ACCOUNTING
SOLUTIONS LTDA, e terá sede na Rua Gonçalves Dias, n.º 565, Bairro Centro, Anxeo I,
Andar 1, Sala 4, Município de Imperatriz, Estado do Maranhão, CEP: 65.900-450; 

'''),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

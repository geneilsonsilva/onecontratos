import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onecontratos/pages/Utils/colors.dart';
import 'package:onecontratos/pages/Utils/responsive.dart';
import 'package:onecontratos/pages/Utils/routes.dart';
import 'package:onecontratos/pages/widgets/emitir_contract.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final List<Service> services = [];

  bool isExpanded = true;

  @override
  void initState() {
    super.initState();

    // Popula a lista de serviços
    services.addAll([
      Service(
        title: "Emitir Contratos",
        icon: Icons.description,
        onTap: () {}, // Inicialmente, sem ação definida
      ),
      Service(
        title: "Alteração de Empresa",
        icon: Icons.autorenew,
        onTap: () {}, // Inicialmente, sem ação definida
      ),
      Service(
        title: "Ata/Estatuto",
        icon: Icons.merge_type_outlined,
        onTap: () {}, // Inicialmente, sem ação definida
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Atualiza a lista de serviços com o onTap correto
    services[0] = Service(
      title: "Emitir Contratos",
      icon: Icons.description,
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.emitirContratos);
      },
    );
    services[1] = Service(
      title: "Alteração de Empresa",
      icon: Icons.autorenew,
      onTap: () {
        // Adicione a lógica de navegação desejada aqui
      },
    );
    services[2] = Service(
      title: "Ata/Estatuto",
      icon: Icons.merge_type_outlined,
      onTap: () {
        // Adicione a lógica de navegação desejada aqui
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        toolbarHeight: 50,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: Text(
          'Todos os recursos',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              const Icon(
                Icons.business_outlined,
              ),
              const SizedBox(width: 8),
              Text(
                'Soluções Contábeis',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(
              //     Icons.logout_outlined,
              //     color: AppColors.white,
              //   ),
              // )
            ],
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildMenuItem(
                    icon: Icons.home_outlined,
                    label: "Home",
                    isSelected: true,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.star_border,
                    label: "Acesso Recentes",
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.assignment_outlined,
                    label: "Abertura de\nEmpresa",
                    // hasDropdown: true,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.receipt_long_outlined,
                    label: "Alteração de\nEmpresa",
                    // hasDropdown: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Segunda seção: Estatísticas
            _infoCard(
              title: "Estatísticas",
              icon: Icons.bar_chart,
              content: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        'assets/image/screen.png',
                        width: 400,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Você ganhou acesso ao BI de Custo e Produtividade e só precisa configurar para usar!",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Com o novo painel de indicadores gerenciais da contabilidade, você conseguirá saber o esforço desempenhado por seus colaboradores...",
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Configure aqui >",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.close, color: Colors.grey),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Terceira seção: Novidades
            _infoCard(
              title: "Novidades",
              icon: Icons.public,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _novidadeItem(
                      "Folha de Pagamento",
                      'Novas regras implementadas para Cálculo da Folha de Pagamento.\nFicou muito mais fácil, migre agora',
                      "Veja mais"),
                  _buildDivider(),
                  _novidadeItem(
                      "Novidade",
                      "Transforme a sua gestão de empréstimos e financiamentos bancários.",
                      "Conheça"),
                  _buildDivider(),
                  _novidadeItem(
                      "MIT",
                      "Torne-se um especialista no MIT: ao vivo, 10/02 às 9h",
                      "Inscreva-se"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para os cartões de informação (Estatísticas e Novidades)
  Widget _infoCard(
      {required String title,
      required IconData icon,
      required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  // Widget para os itens de novidade
  Widget _novidadeItem(String title, String description, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          Text(
            action,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMenuItem({
  required IconData icon,
  required String label,
  bool isSelected = false,
  bool hasDropdown = false,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: isSelected
            ? BoxDecoration(
                color:
                    Colors.grey.shade200, // Fundo diferente para o item ativo
                borderRadius: BorderRadius.circular(5),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? Colors.orange : Colors.black87,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.orange : Colors.black87,
                  ),
                ),
                if (hasDropdown)
                  const Icon(Icons.keyboard_arrow_down,
                      size: 18, color: Colors.black54),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDivider() {
  return Container(
    width: 1,
    height: 100,
    color: Colors.grey.shade300,
  );
}

class Service {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const Service({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: service.onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(service.icon, color: AppColors.primaryColor, size: 30),
              const SizedBox(height: 8),
              Text(
                service.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

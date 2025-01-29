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
  bool isExpanded = true;
  int? _selectedIndex;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegação usando as rotas criadas
    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.emitirContratos);
    }
  }

  Widget _buildHomeScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/image/screen.png',
            // fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF1F3F6),
        appBar: MediaQuery.of(context).size.width < 600
            ? AppBar(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                title: Text(
                  'Home',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                centerTitle: true,
                toolbarHeight: 60,
                iconTheme: const IconThemeData(color: AppColors.white),
              )
            : null,
        body: SafeArea(
          child: Stack(
            children: [
              Row(
                children: [
                  if (Responsive.isDesktop(context))
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width * 0.17,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: const Color(0xFFFFFFFF),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  ListTile(
                                    leading: const CircleAvatar(
                                      radius: 20,
                                      // backgroundImage:
                                      //     AssetImage('assets/image/person.png'),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Olá 👋',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.menu,
                                          ),
                                        ),
                                        Text(
                                          'Geneilson',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.menu,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                      thickness: 1, color: Colors.grey[300]),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        buildMenuTile(
                                          icon: Icons.description,
                                          title: "Emitir Contratos",
                                          index: 1,
                                          onTap: () {
                                            _onItemTapped(1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 30,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Navigator(
                          key: _navigatorKey,
                          initialRoute: '/',
                          onGenerateRoute: (RouteSettings settings) {
                            switch (settings.name) {
                              case '/':
                                return MaterialPageRoute(
                                  builder: (context) => _buildHomeScreen(),
                                );
                              // Adicione outras rotas conforme necessário
                              case '/contratos':
                                return MaterialPageRoute(
                                  builder: (context) => const EmitirContratos(),
                                );
                              default:
                                return MaterialPageRoute(
                                  builder: (context) => _buildHomeScreen(),
                                );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildMenuTile({
    required int index,
    required String title,
    required VoidCallback onTap,
    IconData? icon,
    bool isSubTile = false,
  }) {
    bool isSelected = _selectedIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSubTile ? 34 : 5),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.decoretionMenu : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: ListTile(
          leading: icon != null ? Icon(icon, color: AppColors.menu) : null,
          title: isExpanded
              ? Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppColors.menu,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

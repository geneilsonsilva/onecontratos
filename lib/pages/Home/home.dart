import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onecontratos/pages/Utils/colors.dart';
import 'package:onecontratos/pages/Utils/responsive.dart';

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
    _navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => _getSelectPage(index)),
    );
  }

  Widget _getSelectPage(int? selectedIndex) {
    switch (selectedIndex) {
      case 0:
      default:
        return _buildHomeScreen();
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
                                      backgroundImage:
                                          AssetImage('assets/image/person.png'),
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
                                        buildListTile(
                                          icon: Icons.dashboard,
                                          title: "Contratos",
                                          index: 0,
                                          onTap: () {
                                            _onItemTapped(0);
                                          },
                                        ),
                                        // buildListTile(
                                        //   icon: Icons.inventory,
                                        //   title: "Estoque",
                                        //   index: 1,
                                        //   onTap: () {
                                        //     _onItemTapped(0);
                                        //   },
                                        // ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: 5,
                                        //   ),
                                        //   child: ListTile(
                                        //     leading: const Icon(
                                        //         Icons.monetization_on,
                                        //         size: 25,
                                        //         color: AppColors.menu),
                                        //     title: Text(
                                        //       'Vendas',
                                        //       style: GoogleFonts.poppins(
                                        //         fontSize: 15,
                                        //         color: AppColors.menu,
                                        //         fontWeight: FontWeight.w600,
                                        //       ),
                                        //     ),
                                        //     onTap: () {
                                        //       // Navigator.of(context)
                                        //       //     .pushAndRemoveUntil(
                                        //       //   MaterialPageRoute(
                                        //       //     builder: (context) =>
                                        //       //         const PDV(),
                                        //       //   ),
                                        //       //   (route) => false,
                                        //       // );
                                        //     },
                                        //   ),
                                        // ),
                                        // buildListTile(
                                        //   icon: Icons.monetization_on,
                                        //   title: "Vendas",
                                        //   index: 2,
                                        //   onTap: () {
                                        //     if (!isExpanded) {
                                        //       setState(() {
                                        //         isExpanded = true;
                                        //       });
                                        //     }
                                        //     _onItemTapped(0);
                                        //   },
                                        // ),

                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: 5,
                                        //   ),
                                        //   child: ExpansionTile(
                                        //     leading: const Icon(Icons.receipt),
                                        //     iconColor: AppColors.menu,
                                        //     collapsedIconColor: AppColors.menu,
                                        //     title: Text(
                                        //       "Fiscal",
                                        //       style: GoogleFonts.poppins(
                                        //         fontSize: 15,
                                        //         fontWeight: FontWeight.w600,
                                        //         color: AppColors.menu,
                                        //       ),
                                        //     ),
                                        //     // onExpansionChanged: (expanded) {
                                        //     //   if (!expanded) {
                                        //     //     return;
                                        //     //   } else {
                                        //     //     setState(() {
                                        //     //       isExpanded = true;
                                        //     //     });
                                        //     //   }
                                        //     // },
                                        //     children: <Widget>[
                                        //       buildSubListTile(
                                        //         title: "NF-e",
                                        //         index: 4,
                                        //         onTap: () {},
                                        //       ),
                                        //       buildSubListTile(
                                        //         title: "NFC-e",
                                        //         index: 5,
                                        //         onTap: () {},
                                        //       ),
                                        //       buildSubListTile(
                                        //         title: "Sintegra",
                                        //         index: 6,
                                        //         onTap: () {},
                                        //       ),
                                        //       buildSubListTile(
                                        //         title: "SAT",
                                        //         index: 7,
                                        //         onTap: () {},
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
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
                          onGenerateRoute: (settings) {
                            return MaterialPageRoute(
                              builder: (context) =>
                                  _getSelectPage(_selectedIndex),
                            );
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

  Widget buildListTile({
    required int index,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    bool isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
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
          leading: Icon(icon, size: 25, color: AppColors.menu),
          title: isExpanded
              ? Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: isSelected ? AppColors.menu : AppColors.menu,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
          // trailing: isSelected
          //     ? const Icon(
          //         Icons.chevron_right,
          //         size: 25,
          //         color: Color(0xFF404046),
          //       )
          //     : null,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget buildSubListTile({
    required int index,
    required String title,
    required VoidCallback onTap,
  }) {
    bool isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: ListTile(
            title: isExpanded
                ? Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isSelected ? AppColors.menu : AppColors.menu,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
            // trailing: isSelected
            //     ? const Icon(
            //         Icons.chevron_right,
            //         size: 25,
            //         color: AppColors.menu,
            //       )
            //     : null,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

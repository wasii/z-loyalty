import 'package:flutter/material.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_tabbar.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/pages/application/dasboard/dashboard.dart';
import 'package:loyalty_program/pages/application/installation/installation_home.dart';
import 'package:loyalty_program/pages/application/sidemenu/side_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const InstallationHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomSidebarDrawer(
        currentScreen: "Dashboard",
        onMenuItemTap: (title) {
          setState(() {
            if (title == "Dashboard") {
              _currentIndex = 0;
            } else if (title == "Installation") {
              _currentIndex = 1;
            }
          });
        },
      ),
      appBar: CustomNavigationBar(
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: _screens[_currentIndex],
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withAlpha(200),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          shape: const CircleBorder(),
          onPressed: () {},
          child: Image.asset(
            "${kIconFolder}Ticonscan.png",
            height: 120,
            width: 120,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomTabBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

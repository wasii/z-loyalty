import 'package:flutter/material.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_tabbar.dart';
import 'package:loyalty_program/components/navigation_bar.dart';
import 'package:loyalty_program/pages/application/claimpoints/claim_poinst.dart';
import 'package:loyalty_program/pages/application/dasboard/dashboard.dart';
import 'package:loyalty_program/pages/application/installation/installation_home.dart';
import 'package:loyalty_program/pages/application/installation/installation_listing.dart';
import 'package:loyalty_program/pages/application/loyaltyreward/loyalty_reward_home.dart';
import 'package:loyalty_program/pages/application/sidemenu/side_menu.dart';
import 'package:loyalty_program/pages/application/pointshistory/pointshistory.dart';
import 'package:loyalty_program/pages/application/userprofile/user_profile.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/authentication/login/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  int _tabCurrentIndex = 0;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const InstallationListing(),
    const ClaimPoints(),
    const LoyaltyRewardHome(),
    const PointsHistoryView(),
    const UserProfile(),
  ];

  final List<String> _screenNames = [
    "Dashboard",
    "Installation",
    "Claim Points",
    "Loyalty Rewards",
    "Points Inventory / History",
    "User Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomSidebarDrawer(
        currentScreen: _screenNames[_currentIndex],
        onMenuItemTap: (title) async {
          if (title == "Logout") {
            await UserPrefsService.clearUser();
            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
            return;
          }
          setState(() {
            if (title == "Dashboard") {
              _currentIndex = 0;
            } else if (title == "Installation") {
              _currentIndex = 1;
            } else if (title == "Claim Points") {
              _currentIndex = 2;
            } else if (title == "Loyalty Rewards") {
              _currentIndex = 3;
            } else if (title == "Points Inventory / History") {
              _currentIndex = 4;
            } else if (title == "User Profile") {
              _currentIndex = 5;
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
          onPressed: () {
            setState(() {
              _currentIndex = 1; // Installation Home
            });
          },
          child: Image.asset(
            "${kIconFolder}Ticonscan.png",
            height: 120,
            width: 120,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomTabBar(
        currentIndex: _tabCurrentIndex,
        onTabSelected: (index) {
          print(index);
          if (index == 0) {
            setState(() {
              _tabCurrentIndex = index;
              _currentIndex = 0; // Dashboard
            });
          } else if (index == 1) {
            setState(() {
              _tabCurrentIndex = index;
              _currentIndex = 3; // Loyalty Rewards (LoyaltyRewardHome)
            });
          } else if (index == 2) {
            // Show "Coming Soon" popup for other tabs
            _showComingSoonDialog();
            // Don't update _tabCurrentIndex to keep previous tab selected
          } else if (index == 3) {
            setState(() {
              _tabCurrentIndex = index;
              _currentIndex = 5; // User Profile
            });
          }
        },
      ),
    );
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Coming Soon"),
        content: const Text("This feature is coming soon!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

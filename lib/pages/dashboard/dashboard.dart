import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/pages/authentication/login/login_page.dart';
import 'package:loyalty_program/pages/dashboard/claim_points/claim_points.dart';
import 'package:loyalty_program/pages/dashboard/installation/search_item.dart';
import 'package:loyalty_program/pages/dashboard/loyalty_rewards/loyalty_rewards.dart';
import 'package:loyalty_program/pages/dashboard/points_inventory/points_inventory.dart';
import 'package:loyalty_program/pages/dashboard/sidemenu/side_menu.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    void handleMenuItemTap(String selectedTitle) {
      if (selectedTitle == "Installation") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SearchNewItem()),
        );
      } else if (selectedTitle == "Claim Points") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ClaimPoints()),
        );
      } else if (selectedTitle == "Loyalty Rewards") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoyaltyRewards()),
        );
      } else if (selectedTitle == "Points Inventory\n/ History") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PointsInventoryHistory()),
        );
      } else if (selectedTitle == "Logout") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()), // 👈 your login page
          (route) => false, // 👈 remove all previous routes
        );
      }
    }

    return Scaffold(
      drawer: CustomSidebarDrawer(
        currentScreen: "Home",
        onMenuItemTap: handleMenuItemTap,
      ),
      appBar: AppBar(backgroundColor: kPrimaryColor, elevation: 1),
      body: SafeArea(
        child: CommonScaffoldLayout(
          title: "Home",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MY CURRENT AVAILABLE",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                "POINTS: 0",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildRewardImage("$kBGFolder/reward1.png"),
                    SizedBox(height: 30),
                    _buildRewardImage("$kBGFolder/reward1.png"),
                    SizedBox(height: 30),
                    _buildRewardImage("$kBGFolder/reward1.png"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardImage(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(200),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          height: 180,
          width: double.infinity,
        ),
      ),
    );
  }
}

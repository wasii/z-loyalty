// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/models/dashboard_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
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
  String _points = "0";
  bool isLoading = false;
  DashboardPointsModel? dashboardPointsModel;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardData();
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (dashboardPointsModel != null) {
      _points = dashboardPointsModel!.myCurrentAvailablePoints;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleMenuItemTap(String selectedTitle) async {
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
        await UserPrefsService.clearUser();
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
      body: Stack(
        children: [
          SafeArea(
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
                    "POINTS: $_points",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child:
                        dashboardPointsModel != null &&
                            dashboardPointsModel!.links.isNotEmpty
                        ? ListView.builder(
                            itemCount: dashboardPointsModel!.links.length,
                            itemBuilder: (context, index) {
                              final imageUrl =
                                  dashboardPointsModel!.links[index];
                              return Column(
                                children: [
                                  _buildRewardImage(imageUrl),
                                  const SizedBox(height: 30),
                                ],
                              );
                            },
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) Loader(),
        ],
      ),
    );
  }

  Widget _buildRewardImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: 180,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image)),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 180,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  void dashboardData() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      var user = await UserPrefsService.getUser();
      final response = await api.request(
        path: DashboardGetPoints,
        type: RequestType.post,
        data: {'user_id': user?.id},
        useFormData: true,
      );

      final json = response.data;
      final dashboard = DashboardPointsModel.fromJson(json);

      if (dashboard.error == 0) {
        setState(() {
          dashboardPointsModel = dashboard;
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Dashboard Failed"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}

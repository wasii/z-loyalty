// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/table_cell.dart';
import 'package:loyalty_program/models/claim_points_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/authentication/login/login_page.dart';
import 'package:loyalty_program/pages/dashboard/dashboard.dart';
import 'package:loyalty_program/pages/dashboard/installation/search_item.dart';
import 'package:loyalty_program/pages/dashboard/loyalty_rewards/loyalty_rewards.dart';
import 'package:loyalty_program/pages/dashboard/points_inventory/points_inventory.dart';
import 'package:loyalty_program/pages/dashboard/sidemenu/side_menu.dart';

class ClaimPoints extends StatefulWidget {
  const ClaimPoints({super.key});

  @override
  State<ClaimPoints> createState() => _ClaimPointsState();
}

class _ClaimPointsState extends State<ClaimPoints> {
  bool isLoading = false;
  List<InstallationClaim> claims = [];
  bool showCash = false;
  bool showBike = false;
  bool showUmrah = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getClaimPoints();
    });
  }

  void handleMenuItemTap(String selectedTitle) async {
    if (selectedTitle == "Home") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Dashboard()),
      );
    } else if (selectedTitle == "Installation") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SearchNewItem()),
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

  @override
  Widget build(BuildContext context) {
    int total = claims.fold(0, (sum, item) => sum + item.pointsEarned);
    return Scaffold(
      drawer: CustomSidebarDrawer(
        currentScreen: "Claim Points",
        onMenuItemTap: handleMenuItemTap,
      ),
      appBar: AppBar(backgroundColor: kPrimaryColor, elevation: 1),
      body: Stack(
        children: [
          CommonScaffoldLayout(
            title: 'Claim Points',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                      },
                      children: [
                        for (int i = 0; i < claims.length; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Colors
                                        .grey
                                        .shade100 // even rows
                                  : Colors.grey.shade300,
                            ),
                            children: [
                              tableCell(claims[i].serialNumber),
                              tableCell(claims[i].itemInstalled),
                              tableCell(claims[i].pointsEarned.toString()),
                            ],
                          ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          children: [
                            tableCell(''),
                            tableCell(''),
                            tableCell('Total $total'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) Loader(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 40), // screen side padding
        child: Builder(
          builder: (context) {
            final List<String> buttonTitles = [
              'Claim Cash',
              'Claim Bike',
              'Claim Umrah Package',
            ];

            List<Widget> buttons = List.generate(3, (index) {
              bool isEnabled = false;
              if (index == 0 && showCash) isEnabled = true;
              if (index == 1 && showBike) isEnabled = true;
              if (index == 2 && showUmrah) isEnabled = true;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: IntrinsicWidth(
                  child: CustomPrimaryButton(
                    text: buttonTitles[index],
                    isDisabled: isEnabled,
                    onPressed: () {
                      showCustomPopup(context, buttonTitles[index]);
                    },
                    showImage: false,
                    buttonHeight: 40,
                    fontSize: 11,
                  ),
                ),
              );
            });

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons,
            );
          },
        ),
      ),
    );
  }

  void showCustomPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to $message?'),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Cancel Button (Left - 50%)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: kPrimaryColor),
                              ),
                            ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          kPrimaryColor,
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // OK Button (Right - 50%)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          kPrimaryColor,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void getClaimPoints() async {
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final response = await api.request(
        path: GetClaimPoints,
        type: RequestType.post,
        data: {'user_id': 68},
        useFormData: true,
      );

      final json = response.data;
      final claimPoints = InstallationClaimsResponse.fromJson(json);
      if (claimPoints.error == 0) {
        setState(() {
          claims = claimPoints.installationClaims;
          showCash = claimPoints.showCash;
          showBike = claimPoints.showBike;
          showUmrah = claimPoints.showUmrah;
        });
      } else {}
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Claim Points Failed"),
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

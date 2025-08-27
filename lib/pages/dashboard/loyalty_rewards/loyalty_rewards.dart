// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/components/table_cell.dart';
import 'package:loyalty_program/models/loyalty_rewards_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/authentication/login/login_page.dart';
import 'package:loyalty_program/pages/dashboard/claim_points/claim_points.dart';
import 'package:loyalty_program/pages/dashboard/dashboard.dart';
import 'package:loyalty_program/pages/dashboard/installation/search_item.dart';
import 'package:loyalty_program/pages/dashboard/points_inventory/points_inventory.dart';
import 'package:loyalty_program/pages/dashboard/sidemenu/side_menu.dart';

class LoyaltyRewards extends StatefulWidget {
  const LoyaltyRewards({super.key});

  @override
  State<LoyaltyRewards> createState() => _LoyaltyRewardsState();
}

class _LoyaltyRewardsState extends State<LoyaltyRewards> {
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
    } else if (selectedTitle == "Claim Points") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ClaimPoints()),
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

  bool isLoading = false;
  List<LoyaltyReward> rewards = [];

  @override
  void initState() {
    super.initState();
    getLoyaltyRewardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSidebarDrawer(
        currentScreen: "Loyalty Rewards",
        onMenuItemTap: handleMenuItemTap,
      ),
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            onChanged: (value) {
              print("Search: $value");
            },
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: kDefaultTextFieldColor.withAlpha(30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.white),
            ),
          ),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 1,
      ),
      body: Stack(
        children: [
          CommonScaffoldLayout(
            title: "Loyalty Rewards",
            child: Column(
              children: [
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      children: [
                        tableHeader('Date'),
                        tableHeader("Points"),
                        tableHeader("Details"),
                        tableHeader("Remarks"),
                        tableHeader("Files"),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                      },
                      children: [
                        for (int i = 0; i < rewards.length; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Colors
                                        .grey
                                        .shade100 // even rows
                                  : Colors.grey.shade300,
                            ),
                            children: [
                              tableCell(rewards[i].date),
                              tableCell(rewards[i].points.toString()),
                              tableCell(rewards[i].rewardClaimDetails ?? ''),
                              tableCell(rewards[i].rewardRemarks ?? ''),
                              rewards[i].rewardAttachments.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        showNetworkImagePopup(
                                          context,
                                          rewards[i]
                                              .rewardAttachments
                                              .first
                                              .link,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          rewards[i]
                                              .rewardAttachments
                                              .first
                                              .linkThumbnail,
                                          height: 30,
                                          width: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(),
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
    );
  }

  void showImagePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user can't dismiss by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 24,
          ), // horizontal margin
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 📷 Image Section
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    '$kBGFolder/bike-dummy-image.jpeg',
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                // ❌ Close Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close, color: kPrimaryColor),
                  label: Text("Close", style: TextStyle(color: kPrimaryColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(color: kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showNetworkImagePopup(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: false, // user can't dismiss by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 24,
          ), // horizontal margin
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close, color: kPrimaryColor),
                  label: Text("Close", style: TextStyle(color: kPrimaryColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(color: kPrimaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getLoyaltyRewardList() async {
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final response = await api.request(
        path: GetLoyaltyRewards,
        type: RequestType.post,
        data: {'user_id': 65},
        useFormData: true,
      );

      final json = response.data;
      final claimPoints = LoyaltyRewardsResponse.fromJson(json);
      if (claimPoints.error == 0) {
        setState(() {
          rewards = claimPoints.loyaltyRewards;
        });
      } else {}
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Loyalty Rewards Failed"),
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

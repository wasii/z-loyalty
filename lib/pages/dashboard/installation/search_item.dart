// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_input_textfield.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/components/loader.dart';
import 'package:loyalty_program/models/verify_serial_number_model.dart';
import 'package:loyalty_program/network/api_service.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/authentication/login/login_page.dart';
import 'package:loyalty_program/pages/dashboard/claim_points/claim_points.dart';
import 'package:loyalty_program/pages/dashboard/dashboard.dart';
import 'package:loyalty_program/pages/dashboard/installation/add_new_item.dart';
import 'package:loyalty_program/pages/dashboard/loyalty_rewards/loyalty_rewards.dart';
import 'package:loyalty_program/pages/dashboard/points_inventory/points_inventory.dart';
import 'package:loyalty_program/pages/dashboard/sidemenu/side_menu.dart';

class SearchNewItem extends StatefulWidget {
  const SearchNewItem({super.key});

  @override
  State<SearchNewItem> createState() => _SearchNewItemState();
}

class _SearchNewItemState extends State<SearchNewItem> {
  final TextEditingController addSerialNumberController =
      TextEditingController();

  bool isButtonEnabled = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    addSerialNumberController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = addSerialNumberController.text.length == 8;
    });
  }

  @override
  void dispose() {
    addSerialNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleMenuItemTap(String selectedTitle) async {
      if (selectedTitle == "Home") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Dashboard()),
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
      } else if (selectedTitle == "Loyalty Rewards") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoyaltyRewards()),
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
        currentScreen: "Installation",
        onMenuItemTap: handleMenuItemTap,
      ),
      appBar: AppBar(backgroundColor: kPrimaryColor, elevation: 1),
      body: Stack(
        children: [
          CommonScaffoldLayout(
            title: 'Installation',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "INSTALLATION, ADD NEW",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    CustomInputField(
                      controller: addSerialNumberController,
                      headingText: "Serial Number",
                      hintText: 'Enter your 8-digits serial number',
                      isRequired: true,
                      textHeight: 57,
                    ),
                    Text(
                      "Please scratch your loyalty card and enter the 8-digit serial number.",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Spacer(),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: CustomPrimaryButton(
                    text: 'Search',
                    isDisabled: isButtonEnabled,
                    onPressed: () {
                      verifySerialNumber();
                    },
                    showImage: false,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) Loader(),
        ],
      ),
      // bottomNavigationBar:
      // ),
    );
  }

  void verifySerialNumber() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final api = ApiService();
      final response = await api.request(
        path: VerifySerialNumber,
        type: RequestType.post,
        data: {'serial_number': addSerialNumberController.text},
        useFormData: true,
      );

      final json = response.data;
      final verify_serial = VerifySerialNumberModel.fromJson(json);

      if (verify_serial.error == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNewItem()),
        );
        addSerialNumberController.text = '';
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Verify Serial Failed"),
            content: Text(verify_serial.message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Verify Serial Failed"),
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

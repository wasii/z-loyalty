import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/components/secondary_button.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_earning_cell.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_earning_header.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_header.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_point_successful.dart';
import 'package:loyalty_program/pages/application/claimpoints/components/claim_points_reward.dart';

class ClaimPoints extends StatefulWidget {
  const ClaimPoints({super.key});

  @override
  State<ClaimPoints> createState() => _ClaimPointsState();
}

class _ClaimPointsState extends State<ClaimPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClaimPointsHeaderSection(),
                  SizedBox(height: 20),
                  ClaimPointRewardSection(
                    title: 'Claim Cash',
                    points: '300',
                    imagePath: '${kIconFolder}iconcash.png',
                    onClaim: () {
                      showCustomPopup(
                        context,
                        'Claim Cash',
                        'iconcash',
                        'Cash',
                      );
                    },
                    editable: true,
                  ),
                  SizedBox(height: 10),
                  ClaimPointRewardSection(
                    title: 'Bike Prize',
                    points: '1000',
                    imagePath: '${kIconFolder}iconbike.png',
                    onClaim: () {
                      showCustomPopup(
                        context,
                        'Claim Bike',
                        'iconbike',
                        'Bike',
                      );
                    },
                    editable: true,
                  ),
                  SizedBox(height: 10),
                  ClaimPointRewardSection(
                    title: 'Umrah Package',
                    points: '3000',
                    imagePath: '${kIconFolder}iconumrah.png',
                    onClaim: () {
                      showCustomPopup(
                        context,
                        'Claim Umrah Package',
                        'iconumrah',
                        'Umrah',
                      );
                    },
                    editable: false,
                  ),

                  SizedBox(height: 20),
                  ClaimPointsEarningHeadingSection(),
                  SizedBox(height: 10),
                  ClaimPointsEarningHistoryCell(
                    title: 'Solar Hybrid Inverter 1.6 (KVA)',
                    seiralnumber: '72901063',
                    points: '+30',
                    date: 'Sep 23, 2025',
                  ),
                  SizedBox(height: 10),
                  ClaimPointsEarningHistoryCell(
                    title: 'Solar Hybrid Inverter 1.6 (KVA)',
                    seiralnumber: 'FGH85FF',
                    points: '+30',
                    date: 'Sep 21, 2025',
                  ),
                  SizedBox(height: 10),
                  ClaimPointsEarningHistoryCell(
                    title: 'Solar Hybrid Inverter 1.6 (KVA)',
                    seiralnumber: '98PPOQQ',
                    points: '+30',
                    date: 'Sep 19, 2025',
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomPopup(
    BuildContext parentContext,
    String title,
    String icon,
    String reward,
  ) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Image
                Image.asset(
                  title == 'Claim Bike'
                      ? '${kBGFolder}bgBike.png'
                      : '$kIconFolder$icon.png',
                  height: 134,
                  width: 230,
                ),

                const SizedBox(height: 16),

                /// Title / Text
                Text(
                  "Are you Sure to\n$title",
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: kTextFieldHeadingNameColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                /// TextField
                AppTextField(
                  controller: _controller,
                  hintText: 'Enter remarks (optional)',
                  prefixImage: 'iconchat.png',
                ),

                const SizedBox(height: 20),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Claim',
                        onPressed: () {
                          print("User typed: ${_controller.text}");
                          Navigator.pop(context); // Pehle popup band karo

                          // Ab 2 second baad dusri screen par jao
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.push(
                              parentContext,
                              MaterialPageRoute(
                                builder: (context) => ClaimPointSuccessful(
                                  rewardName: reward,
                                  icon: title == 'Claim Bike'
                                      ? '${kBGFolder}bgBike.png'
                                      : '$kIconFolder$icon.png',
                                ), // yahan apni screen
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

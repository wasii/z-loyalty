import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/app_text_field.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_heading.dart';
import 'package:loyalty_program/components/primary_button.dart';
import 'package:loyalty_program/components/secondary_button.dart';
import 'package:loyalty_program/pages/application/installation/installation_details.dart';

class InstallationHome extends StatefulWidget {
  const InstallationHome({super.key});

  @override
  State<InstallationHome> createState() => _InstallationHomeState();
}

class _InstallationHomeState extends State<InstallationHome> {
  final TextEditingController inputController = TextEditingController();
  bool isLoading = false;
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
  }

  void _updateButtonState() {
    setState(() {
      isVerified = true;
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeading(heading: 'Scan Loyalty Card'),
                    SizedBox(height: 20),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kBoxBackgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "${kIconFolder}iconimagepreview.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Image Preview",
                            style: GoogleFonts.inter(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: 'Scan Now',
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: PrimaryButton(
                            text: 'Browse',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 229,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kBoxBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Enter Loyalty Card",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 25),
                            AppTextField(
                              controller: inputController,
                              hintText: 'Loyalty Code',
                              prefixImage: "iconcard.png",
                            ),
                            SizedBox(height: 25),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Verify Now',
                                    onPressed: () {
                                      _updateButtonState();
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Next',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const InstallationDetails(),
                                        ),
                                      );
                                    },
                                    enabled: isVerified,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

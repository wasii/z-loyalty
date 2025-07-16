import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/common_scaffold_layout.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/custom_primary_button.dart';
import 'package:loyalty_program/pages/dashboard/dashboard.dart';

class ItemAddedSuccessfully extends StatelessWidget {
  const ItemAddedSuccessfully({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: kPrimaryColor,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: CommonScaffoldLayout(
        title: 'Installation',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                children: [
                  TextSpan(text: "You have earned "),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text(
                      "30",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(
                    text: " points",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0),
            Image.asset(
              '${kLogoFolder}ziewnic_horizontal_logo.png',
              height: 60,
            ),
            //Congratulations
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(60),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: Offset(0, 8), // changes position of shadow
                  ),
                ],
              ),
              child: Image.asset(
                '${kBGFolder}Congratulations.png',
                height: 250,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
        child: CustomPrimaryButton(
          text: 'Back to Home',
          isDisabled: true,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => Dashboard()),
              (route) => false,
            );
          },
          showImage: false,
        ),
      ),
    );
  }
}

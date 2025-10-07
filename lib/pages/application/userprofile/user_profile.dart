import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/secondary_button.dart';
import 'package:loyalty_program/pages/application/userprofile/edit_user_profile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

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
                  UserProfileHeader(),
                  SizedBox(height: 20),
                  UserProfileRowCell(title: 'Full Name', value: 'Afif Shaukat'),
                  SizedBox(height: 5),
                  UserProfileRowCell(title: 'Username', value: 'afif.shaukat'),
                  SizedBox(height: 5),
                  UserProfileRowCell(title: 'Contact', value: '+923345067987'),

                  SizedBox(height: 5),
                  UserProfileRowCell(title: 'Email', value: 'abc@gmail.com'),

                  SizedBox(height: 5),
                  UserProfileRowCell(title: 'City', value: 'Punjab'),

                  SizedBox(height: 5),
                  UserProfileRowCell(
                    title: 'Address',
                    value: 'Lahi Bazar Akhara Chooni Pehlwan, Sialkot, Punjab',
                  ),

                  SizedBox(height: 5),
                  UserProfileRowCell(
                    title: 'Bank Account',
                    value: 'PK40MEZN0000001123456702',
                  ),

                  SizedBox(height: 20),

                  SecondaryButton(
                    text: 'Delete Account',
                    onPressed: () {},
                    textColor: kErrorBackColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Account Details',
          style: GoogleFonts.inter(
            fontSize: 26,
            color: kTextHeadingColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditUserProfile()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Edit",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class UserProfileRowCell extends StatelessWidget {
  final String title;
  final String value;
  const UserProfileRowCell({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: kTextFieldPlaceholderColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: kTextFieldHeadingNameColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

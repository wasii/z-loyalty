import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/components/secondary_button.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/network/user_pref_services.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserModel? _user;
  bool _loading = true;
  String _display(String? value) {
    if (value == null) return 'N/A';
    final trimmed = value.trim();
    return trimmed.isEmpty ? 'N/A' : trimmed;
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserPrefsService.getUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _loading = false;
    });
  }

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
                  if (_loading)
                    Center(child: CircularProgressIndicator())
                  else ...[
                    UserProfileRowCell(
                      title: 'Full Name',
                      value: _display(_user?.name),
                    ),
                    SizedBox(height: 5),
                    UserProfileRowCell(
                      title: 'Username',
                      value: _display(_user?.username),
                    ),
                    SizedBox(height: 5),
                    UserProfileRowCell(
                      title: 'Contact',
                      value: _display(_user?.contactNos),
                    ),
                    SizedBox(height: 5),
                    UserProfileRowCell(
                      title: 'Email',
                      value: _display(_user?.email),
                    ),
                    SizedBox(height: 5),
                    UserProfileRowCell(
                      title: 'City',
                      value: _display(_user?.city),
                    ),
                    SizedBox(height: 5),
                    UserProfileRowCell(
                      title: 'Address',
                      value: _display(_user?.address),
                    ),
                    SizedBox(height: 5),
                    UserProfileRowCell(
                      title: 'Bank Account',
                      value: _display(_user?.bankAccountDetails),
                    ),
                    SizedBox(height: 20),
                    SecondaryButton(
                      text: 'Delete Account',
                      onPressed: () {},
                      textColor: kErrorBackColor,
                    ),
                  ],
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
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Coming soon'),
                content: const Text('This feature is coming soon.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/network/user_pref_services.dart';

class CustomSidebarDrawer extends StatefulWidget {
  final String currentScreen;
  final void Function(String title) onMenuItemTap;

  const CustomSidebarDrawer({
    super.key,
    required this.currentScreen,
    required this.onMenuItemTap,
  });

  @override
  State<CustomSidebarDrawer> createState() => _CustomSidebarDrawerState();
}

class _CustomSidebarDrawerState extends State<CustomSidebarDrawer> {
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserPrefsService.getUser();
    if (!mounted) return;
    setState(() {
      name = user?.name ?? "Guest User";
      email = user?.email ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            // 👇 Logo & Branding
            Center(
              child: Column(
                children: [
                  Image.asset(
                    '$kLogoFolder/ziewnic_vertical_logo.png',
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 👇 Menu Items
            _buildMenuItem(
              "Dashboard",
              isActive: widget.currentScreen == "Dashboard",
            ),
            _buildMenuItem(
              "Installation",
              isActive: widget.currentScreen == "Installation",
            ),
            _buildMenuItem(
              "Claim Points",
              isActive: widget.currentScreen == "Claim Points",
            ),
            _buildMenuItem(
              "Loyalty Rewards",
              isActive: widget.currentScreen == "Loyalty Rewards",
            ),
            _buildMenuItem(
              "Points Inventory / History",
              isActive: widget.currentScreen == "Points Inventory / History",
            ),
            _buildMenuItem(
              "Account",
              isActive: widget.currentScreen == "Account",
            ),

            // Disabled Lucky Draw
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: const [
                  Text(
                    "Lucky Draw",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Coming Soon",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 👇 Logout
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    widget.onMenuItemTap("Logout");
                  });
                },
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: kPrimaryColor, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Log out",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  Widget _buildMenuItem(String title, {bool isActive = false}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Future.delayed(const Duration(milliseconds: 300), () {
          widget.onMenuItemTap(title);
        });
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: isActive
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor, Colors.white],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

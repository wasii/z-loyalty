import 'package:flutter/material.dart';
import 'package:loyalty_program/components/constants.dart';

class CustomSidebarDrawer extends StatelessWidget {
  final String currentScreen; // 👈 add this
  final void Function(String title) onMenuItemTap;

  const CustomSidebarDrawer({
    super.key,
    required this.currentScreen,
    required this.onMenuItemTap,
  });

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sufiyan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    "muhammadsufiyan777@gamil.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 40, thickness: 1),
            _buildMenuItem(
              context,
              Icons.home,
              "Home",
              isActive: currentScreen == "Home",
            ),
            _buildMenuItem(
              context,
              Icons.build,
              "Installation",
              isActive: currentScreen == "Installation",
            ),
            _buildMenuItem(
              context,
              Icons.monetization_on,
              "Claim Points",
              isActive: currentScreen == "Claim Points",
            ),
            _buildMenuItem(
              context,
              Icons.card_giftcard,
              "Loyalty Rewards",
              isActive: currentScreen == "Loyalty Rewards",
            ),
            _buildMenuItem(
              context,
              Icons.history,
              "Points Inventory\n/ History",
              isActive: currentScreen == "Points Inventory\n/ History",
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.black87,
                  minimumSize: Size(double.infinity, 50),
                  shape: StadiumBorder(),
                  elevation: 4,
                ),
                onPressed: () {
                  print("Logout tapped");
                  Navigator.pop(context); // Close drawer
                  Future.delayed(Duration(milliseconds: 300), () {
                    onMenuItemTap("Logout"); // Navigate after closing
                  });
                },
                icon: Icon(Icons.logout),
                label: Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool isActive = false,
  }) {
    final activeColor = kPrimaryColor;
    final defaultColor = Colors.black;

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(); // Close drawer
        Future.delayed(Duration(milliseconds: 300), () {
          onMenuItemTap(title); // Navigate after closing
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: isActive ? activeColor : defaultColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? activeColor : defaultColor,
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

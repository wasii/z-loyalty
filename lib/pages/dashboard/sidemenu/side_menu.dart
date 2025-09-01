import 'package:flutter/material.dart';
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
    _loadUser(); // 👈 drawer open hote hi call hoga
  }

  Future<void> _loadUser() async {
    final user = await UserPrefsService.getUser(); // 👈 tumhari service call
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
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('$kIconFolder/user.png'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name ?? "Loading...",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      email ?? "Loading...",
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 40, thickness: 1),
            _buildMenuItem(
              context,
              Icons.home,
              "Home",
              isActive: widget.currentScreen == "Home",
            ),
            _buildMenuItem(
              context,
              Icons.build,
              "Installation",
              isActive: widget.currentScreen == "Installation",
            ),
            _buildMenuItem(
              context,
              Icons.monetization_on,
              "Claim Points",
              isActive: widget.currentScreen == "Claim Points",
            ),
            _buildMenuItem(
              context,
              Icons.card_giftcard,
              "Loyalty Rewards",
              isActive: widget.currentScreen == "Loyalty Rewards",
            ),
            _buildMenuItem(
              context,
              Icons.history,
              "Points Inventory\n/ History",
              isActive: widget.currentScreen == "Points Inventory\n/ History",
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder(),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    widget.onMenuItemTap("Logout");
                  });
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
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
        Navigator.of(context).pop();
        Future.delayed(const Duration(milliseconds: 300), () {
          widget.onMenuItemTap(title);
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

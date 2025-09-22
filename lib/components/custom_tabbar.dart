import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyalty_program/components/constants.dart';

class CustomBottomTabBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  State<CustomBottomTabBar> createState() => _CustomBottomTabBarState();
}

class _CustomBottomTabBarState extends State<CustomBottomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // halka shadow
            offset: Offset(0, -2), // upar se shadow niche ki taraf
            blurRadius: 6,
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                "${kIconFolder}Ticondashboard.png",
                "${kIconFolder}Ticondashboard.png",
                "Dashboard",
                0,
              ),
              _buildTabItem(
                "${kIconFolder}Ticonrewards.png",
                "${kIconFolder}Ticonrewards.png",
                "Rewards",
                1,
              ),
              const SizedBox(width: 50),
              _buildTabItem(
                "${kIconFolder}Ticonluckydraw.png",
                "${kIconFolder}Ticonluckydraw.png",
                "Lucky Draw",
                2,
              ),
              _buildTabItem(
                "${kIconFolder}Ticonaccount.png",
                "${kIconFolder}Ticonaccount.png",
                "Account",
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    String iconPath,
    String selectedIconPath,
    String label,
    int index,
  ) {
    final isSelected = widget.currentIndex == index;
    return InkWell(
      onTap: () => widget.onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isSelected ? selectedIconPath : iconPath,
            height: 24,
            width: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: kTextHeadingColor,
            ),
          ),
        ],
      ),
    );
  }
}

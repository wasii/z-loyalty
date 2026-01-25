import 'package:flutter/material.dart';
import 'package:loyalty_program/components/constants.dart';

class CustomNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onMenuTap;

  const CustomNavigationBar({Key? key, this.onMenuTap}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Image.asset(
          "${kIconFolder}iconhamburger.png", // apni image ka path
          height: 24,
          width: 24,
        ),
        onPressed: onMenuTap,
      ),
      title: Image.asset("${kLogoFolder}ziewnic_vertical_logo.png", height: 50),
      centerTitle: true,
      actions: [
        // GestureDetector(
        //   child: const Padding(
        //     padding: EdgeInsets.only(right: 12),
        //     child: CircleAvatar(
        //       radius: 18,
        //       backgroundImage: AssetImage("${kBGFolder}dummy_picture.png"),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class CustomNavigationBarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBackTap;
  final bool isVisible;
  final bool showImage;

  const CustomNavigationBarWithBackButton({
    Key? key,
    this.onBackTap,
    this.isVisible = true,
    this.showImage = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: isVisible
          ? IconButton(
              icon: Image.asset(
                "${kIconFolder}iconback.png", // apni image ka path
                height: 34,
                width: 34,
              ),
              onPressed: onBackTap,
            )
          : null,
      title: Image.asset("${kLogoFolder}ziewnic_vertical_logo.png", height: 50),
      centerTitle: true,
      actions: showImage
          ? [
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(
                      "${kBGFolder}dummy_picture.png",
                    ),
                  ),
                ),
              ),
            ]
          : null,
    );
  }
}

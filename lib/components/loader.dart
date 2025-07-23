import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(50),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

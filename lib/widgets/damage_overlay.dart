import 'package:flutter/material.dart';

class RedOverlay extends StatelessWidget {
  const RedOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withAlpha(30),
    );
  }
}
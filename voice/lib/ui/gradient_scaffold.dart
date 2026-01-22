import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;

  const GradientScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
decoration: const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F2027), // dark blue/black
      Color(0xFF203A43), // teal
      Color(0xFFF2994A), // orange highlight
    ],
  ),
),

        child: SafeArea(child: child),
      ),
    );
  }
}

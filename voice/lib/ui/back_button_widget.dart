import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  final Color color;

  const BackIconButton({
    super.key,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: color,
        size: 22,
      ),
      splashRadius: 24,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

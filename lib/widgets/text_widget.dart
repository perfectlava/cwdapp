import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final double height;
  const TextWidget({
    super.key,
    required this.text,
    required this.color,
    this.size = 0,
    this.height = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size == 0 ? Layout.height(18) : size,
          height: height),
    );
  }
}

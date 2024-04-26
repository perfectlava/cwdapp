import 'package:cwdapp/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;
  const IconAndTextWidget(
      {super.key,
      required this.text,
      this.color = const Color(0xFF76c5bb),
      this.iconColor = const Color(0xFF93ddd4),
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(
          width: 5,
        ),
        TextWidget(text: text, color: color)
      ],
    );
  }
}

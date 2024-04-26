import 'package:cwdapp/utils/app_constant.dart';
import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final TextOverflow overFlow;
  const BigText(
      {super.key,
      required this.text,
      required this.color,
      this.size = 0,
      this.overFlow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: 1,
        overflow: overFlow,
        softWrap: false,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: color,
          fontSize: size == 0 ? Layout.height(20) : size,
          fontWeight: FontWeight.w400,
        )
        // robotoRegular,
        );
  }
}

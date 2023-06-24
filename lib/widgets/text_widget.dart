import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {Key? key,
      required this.label,
      this.color,
      this.fontweight,
      this.fontSize = 18})
      : super(key: key);

  final double fontSize;
  final Color? color;
  final String label;
  final FontWeight? fontweight;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontWeight: fontweight ?? FontWeight.w500,
      ),
    );
  }
}

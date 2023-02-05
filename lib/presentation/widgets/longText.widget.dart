import 'package:flutter/material.dart';

class LongText extends StatelessWidget {
  final String text;
  final TextOverflow? textOverflow;
  final TextStyle? textStyle;

  const LongText({
    required this.text,
    this.textOverflow,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Text(
        text,
        style: textStyle,
        overflow: textOverflow,
      ),
    );
  }
}

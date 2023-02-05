import 'package:flutter/material.dart';

class ButtonA extends StatelessWidget {
  final String label;
  final Function()? onPressed;

  const ButtonA({
    required this.label,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: const Color(0xFF252525),
          textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          )),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

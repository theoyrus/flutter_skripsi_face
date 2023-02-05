import 'package:flutter/material.dart';

class ButtonLoading extends StatelessWidget {
  final MaterialStateProperty<Color?>? backgroundColor;
  final Widget? defaultLabel;
  final bool? isLoading;
  final void Function()? onPressed;

  const ButtonLoading({
    Key? key,
    this.backgroundColor,
    this.defaultLabel,
    this.isLoading,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: backgroundColor,
        padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
      ),
      onPressed: isLoading! ? null : onPressed,
      child: isLoading!
          ? Container(
              constraints: BoxConstraints.tight(const Size(20, 20)),
              child: const Center(child: CircularProgressIndicator()))
          : defaultLabel,
    );
  }
}

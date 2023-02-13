import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class DialogWidget extends StatelessWidget {
  final String? title;
  final String? body;
  final String? okText;
  final Function? onOK;

  const DialogWidget({
    this.title,
    this.body,
    this.okText,
    this.onOK,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.topCenter,
      // child: SingleChildScrollView(
      child: ListView(
        children: [
          // title
          Text(
            title ?? 'Popup',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(body ?? ''),
          ElevatedButton(
            onPressed: () {
              SmartDialog.dismiss();
              onOK?.call();
            },
            child: Text(okText ?? 'OK'),
          )
        ],
      ),
      // ),
    );
  }
}

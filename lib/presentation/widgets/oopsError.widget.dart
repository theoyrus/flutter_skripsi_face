import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Widget oopsError(FlutterErrorDetails error) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Emmh, tunggu sebentar ... "),
            Icon(MdiIcons.emoticonExcited),
          ],
        ),
      ),
      // Center(
      //   child: Text(error.toString()),
      // )
    ],
  );
}

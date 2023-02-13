import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../presentation/widgets/dialog.widget.dart';

void dialogInfo({
  String title = '',
  String body = '',
  String okText = 'OK',
  Function? onOK,
}) async {
  SmartDialog.show(
    backDismiss: false,
    clickMaskDismiss: false,
    builder: (_) => DialogWidget(
      title: title,
      body: body,
      okText: okText,
      onOK: onOK,
    ),
  );
}

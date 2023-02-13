import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'env/env.dart';
import 'infrastructure/logs/sentry/sentry.service.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'infrastructure/theme/app_colors.dart';
import 'infrastructure/theme/theme.controller.dart';
import 'presentation/widgets/oopsError.widget.dart';

void mainOld() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initialRoute = await Routes.initialRoute;
  // Initialize Get Storage
  await GetStorage.init();

  runApp(Main(initialRoute));
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    var initialRoute = await Routes.initialRoute;
    // Initialize Get Storage
    await GetStorage.init();
    // runApp(Main(initialRoute));

    if (isSentryAble()) {
      // SentryService.configure();
      SentryService.setup(() {
        return runApp(
          SentryScreenshotWidget(
            child: Main(initialRoute),
          ),
        );
      });
      SentryService.captureMessage('Release Mode detected!');
    } else {
      runApp(Main(initialRoute));
    }
  }, (exception, stackTrace) async {
    if (isSentryAble()) {
      await SentryService.captureException(exception, stackTrace: stackTrace);
    }
    throw exception;
  });
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main(this.initialRoute, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = oopsError;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: Nav.routes,
      theme: themeDataLight(),
      darkTheme: themeDataDark(),
      themeMode: Get.put(ThemeController()).isDark.value
          ? ThemeMode.dark
          : ThemeMode.light,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}

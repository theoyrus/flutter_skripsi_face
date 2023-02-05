import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../env/env.dart';

class SentryService with SentryFlutter {
  static var dsn = Env.sentryDsn;
  static final SentryClient _sentry = SentryClient(
    SentryOptions(
      dsn: dsn,
    ),
  );

  static void configure() async {
    await SentryFlutter.init(
      (options) {
        options.dsn = dsn;
      },
    );
  }

  static Future<void> setup(AppRunner appRunner) async {
    await SentryFlutter.init((options) {
      options.dsn = dsn;
      options.attachScreenshot = true;
    }, appRunner: appRunner);
  }

  static Future<void> captureException(dynamic exception,
      {dynamic stackTrace}) async {
    _sentry.captureException({
      exception: exception,
      stackTrace: stackTrace,
    });
  }

  static Future<void> captureMessage(String message,
      {SentryLevel level = SentryLevel.error}) async {
    _sentry.captureMessage(
      message,
      level: level,
    );
  }
}

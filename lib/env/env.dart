import 'package:envied/envied.dart';

part 'env.g.dart';

// var mode = Platform.environment['MODE'];
// var baseUrl = Platform.environment['BASE_URL'];
const isRelease = bool.fromEnvironment("dart.vm.product");

// helper untuk mendeteksi apakah pakai Sentry
bool Function() isSentryAble = () => isRelease && Env.sentryEnabled;
// bool Function() isSentryAble = () => true; // enable in debugging :D

// @Envied(path: '.env')
@Envied()
abstract class Env {
  @EnviedField(varName: 'MODE', defaultValue: mode)
  static const mode = _Env.mode;

  @EnviedField(varName: 'BASE_URL', defaultValue: baseUrl)
  static const baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'SENTRY_ENABLED')
  static bool sentryEnabled = _Env.sentryEnabled;

  @EnviedField(varName: 'SENTRY_DSN', obfuscate: true)
  static final sentryDsn = _Env.sentryDsn;
}

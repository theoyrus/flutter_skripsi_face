class Routes {
  static Future<String> get initialRoute async {
    return SPLASHSCREEN;
    // return AUTH_LOGIN;
  }

  static const AUTH_LOGIN = '/auth-login';
  static const AUTH_REGISTER = '/auth-register';
  static const BERANDA = '/beranda';
  static const CITRAWAJAH_MY = '/citrawajah-my';
  static const CITRAWAJAH_TAMBAH = '/citrawajah-tambah';
  static const HOME = '/home';
  static const PRESENSI_UTAMA = '/presensi-utama';
  static const REPORT_UTAMA = '/report-utama';
  static const SETTING_GENERAL = '/setting-general';
  static const SETTING_PROFILE = '/setting-profile';
  static const SETTING_TAMPILAN = '/setting-tampilan';
  static const SPLASHSCREEN = '/splashscreen';
  static const PRESENSI_REKAM = '/presensi-rekam';
}

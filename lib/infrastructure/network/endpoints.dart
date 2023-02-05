import '../../env/env.dart';

class EndPoints {
  static String baseUrl = Env.baseUrl;

  // Auth
  // static const String login = '/auth/jwt/create';
  static const String login = '/auth/login';
  static const String jwtRefresh = '/auth/jwt/refresh';
  static const String jwtVerify = '/auth/jwt/verify';

  // Karyawan
  static const String karyawan = '/karyawan';
  static const String karyawanMe = '/karyawan/me';
  static const String divisi = '/divisi';

  // Face Recognition
  static const String citrawajah = '/facerecog/citrawajah';
  static const String training = '/facerecog/training';
  static const String recognize = '/facerecog/recognize';

  // Presensi
  static const String presensi = '/presensi';
}

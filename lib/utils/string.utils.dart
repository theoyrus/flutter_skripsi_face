import 'dart:io';

bool isStringUrl(String str) {
  try {
    final uri = Uri.parse(str);
    return uri.isAbsolute;
  } catch (e) {
    return false;
  }
}

bool isValidPath(String path) {
  final file = File(path);
  return file.existsSync();
}

bool isValidImagePath(String path) {
  bool vp = isValidPath(path);
  bool vurl = isStringUrl(path);
  return vurl ? vurl : (vp ? vp : false);
}

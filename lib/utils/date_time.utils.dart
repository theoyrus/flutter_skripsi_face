import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../infrastructure/network/api_client.dart';

String idFullDateTime(DateTime dateTime) {
  initializeDateFormatting();
  return DateFormat('dd-MM-yyyy hh:mm:ss', 'id').format(dateTime);
}

String idFullDate(DateTime dateTime) {
  initializeDateFormatting();
  return DateFormat('dd-MM-yyyy', 'id').format(dateTime);
}

String idHariBulanTahun(DateTime dateTime) {
  initializeDateFormatting();
  return DateFormat('EEEE, d MMMM yyyy', 'id').format(dateTime);
}

String idDayName(DateTime dateTime) {
  initializeDateFormatting();
  return DateFormat('EEEE', 'id').format(dateTime);
}

String idHariBulan(DateTime dateTime) {
  initializeDateFormatting();
  return DateFormat('d MMM', 'id').format(dateTime);
}

String idTime(DateTime dateTime, {format = 'HH:mm:ss', withTZ = false}) {
  String strdatetime = dateTime.toString();
  if (isValidDateTime(strdatetime)) {
    return DateFormat(format).format(dateTime);
  }
  return '';
}

bool isValidDateTime(String dateTimeString) {
  List<String> formats = [
    'yyyy-MM-ddTHH:mm:ssZ',
    'yyyy-MM-ddTHH:mm:ss',
    'yyyy-MM-dd HH:mm:ss',
    'HH:mm:ss',
    'yyyy-MM-dd',
  ];

  for (String format in formats) {
    try {
      DateFormat dateFormat = DateFormat(format);
      DateTime dateTime = dateFormat.parse(dateTimeString);
      if (dateTime != null) {
        return true;
      }
    } catch (e) {
      continue;
    }
  }
  return false;
}

String enFullDate(DateTime dateTime) {
  initializeDateFormatting();
  return DateFormat('yyyy-MM-dd', 'en').format(dateTime);
}

DateTime parseTime(String timeString) {
  return DateTime.parse(timeString).toLocal();
}

Future<String> getWaktuString({String timezone = 'Asia/Jakarta'}) async {
  try {
    var res = await ApiClient().http.get(
          'https://www.timeapi.io/api/TimeZone/zone?timeZone=$timezone',
        );
    if (res.statusCode == 200) {
      Map<String, dynamic> json = res.data;
      debugPrint(json['currentLocalTime'].toString());
      return json['currentLocalTime'].toString();
    }
  } catch (e, stack) {
    debugPrint('{http error: now calls: $e\n $stack}');
  }
  return 'error';
}

String fullDateTimeNoSpace(DateTime dateTime) {
  initializeDateFormatting();
  return DateFormat('yyyyMMdd_hhmmss_S').format(dateTime);
}

String getMonthNameByIdx(int idx, {String langCode = 'en'}) {
  initializeDateFormatting();
  return DateFormat.MMMM(langCode)
      .format(DateFormat('M').parse(idx.toString()));
}

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

String idTime(DateTime dateTime) {
  return DateFormat('HH:mm:ss').format(dateTime);
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

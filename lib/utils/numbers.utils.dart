import 'package:intl/intl.dart';

String twoDigits(int n) => n.toString().padLeft(2, '0');

final formatRupiah = NumberFormat.simpleCurrency(locale: 'id_ID');

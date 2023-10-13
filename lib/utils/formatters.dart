import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

abstract class AppFormatters {
  static final ipFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'));
}

extension FormatDate on DateTime {
  DateFormat get formatter => DateFormat('yyyy-MM-dd HH:mm:ss');

  String get ymdhms => this.formatter.format(this);

  String get numhms => '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}:${this.second.toString().padLeft(2, '0')}';
  String get numymd => '${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}';
}

extension FormatDuration on Duration {
  String get hms => '${this.inHours}:${this.inMinutes.remainder(60).toString().padLeft(2, '0')}:${this.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}

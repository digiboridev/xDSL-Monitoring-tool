import 'package:flutter/services.dart';

abstract class AppFormatters {
  static final ipFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'));
}

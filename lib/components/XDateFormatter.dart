import 'package:intl/intl.dart' as intl;
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';

class XDateFormater extends ValueFormatter {
  final intl.DateFormat mFormat = intl.DateFormat("HH:mm");

  @override
  String getFormattedValue1(double value) {
    return mFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  }
}

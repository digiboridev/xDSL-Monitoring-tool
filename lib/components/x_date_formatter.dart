import 'package:intl/intl.dart';
import 'package:mp_chart_x/mp/core/value_formatter/value_formatter.dart';

class XDateFormater extends ValueFormatter {
  final mFormat = DateFormat('HH:mm');

  @override
  String getFormattedValue1(double value) {
    return mFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  }
}

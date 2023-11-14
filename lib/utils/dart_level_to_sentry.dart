import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

SentryLevel dartLevel2Sentry(Level level) {
  if (level >= Level.SHOUT) return SentryLevel.fatal;
  if (level == Level.SEVERE) return SentryLevel.error;
  if (level == Level.WARNING) return SentryLevel.warning;
  if (level == Level.INFO) return SentryLevel.info;
  return SentryLevel.debug;
}

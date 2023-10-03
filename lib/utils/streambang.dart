// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'dart:async';

// Just a mixin to make boring add-cancel subscriptions
mixin StreamBang {
  /// List of subscriptions
  final List<StreamSubscription> _subs = [];

  /// Add subscription to list
  void insert(StreamSubscription sub) => _subs.add(sub);

  /// Cancel all subscriptions
  void canshot() => _subs.forEach((sub) => sub.cancel());
}

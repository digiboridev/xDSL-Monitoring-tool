import 'package:xdslmt/models/modemClients/line_stats_collection.dart';

abstract class Client {
  // final String _ip;
  // final String _extIp;

  String get ip;
  String get extIp;
  String get user;
  String get password;

  // Client(
  //     // this._ip,
  //     {
  //   required this.user,
  //   required this.password,
  // });

  Future<LineStatsCollection> get getData;
}

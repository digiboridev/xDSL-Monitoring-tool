import 'LineStatsCollection.dart';

abstract class Client {
  final String _ip;
  final String user;
  final String password;

  Client(this._ip, this.user, this.password);

  Future<LineStatsCollection> get getData {}
}

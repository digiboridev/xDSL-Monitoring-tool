import 'package:xdsl_mt/data/models/app_settings.dart';
import 'package:xdsl_mt/data/models/line_stats.dart';
import 'package:xdsl_mt/data/models/network_unit_type.dart';
import 'package:xdsl_mt/data/net_unit_clients/simulator_impl.dart';

abstract base class NetUnitClient {
  /// IP address of the network unit
  final String ip;

  /// Login credentials
  final String login;

  /// Password credentials
  final String password;

  /// Unique session ID
  final String session;

  /// Fetches line stats from the network unit
  Future<LineStats> fetchStats();

  NetUnitClient({required this.ip, required this.login, required this.password, required this.session});

  factory NetUnitClient.fromType(NetworkUnitType type, String session, String ip, String login, String password) {
    switch (type) {
      case NetworkUnitType.simulator:
        return ClientSimulator(session: session);
      default:
        throw Exception('Unknown NetUnitClient type: $type');
    }
  }

  factory NetUnitClient.fromSettings(AppSettings settings, String session) {
    return NetUnitClient.fromType(settings.nuType, session, settings.host, settings.login, settings.pwd);
  }
}

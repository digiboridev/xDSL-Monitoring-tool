// ignore_for_file: constant_identifier_names
import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_adsl_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_adsl_sh_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_adslcmd_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_adslcmd_sh_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_adslctl_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_adslctl_sh_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_xdslcmd_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_xdslcmd_sh_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_xdslctl_impl.dart';
import 'package:xdslmt/data/net_unit_clients/broadcom_xdslctl_sh_impl.dart';
import 'package:xdslmt/data/net_unit_clients/simulator_impl.dart';
import 'package:xdslmt/data/net_unit_clients/tcp31xx_impl.dart';
import 'package:xdslmt/data/net_unit_clients/trendchip_perfomance_impl.dart';
import 'package:xdslmt/data/net_unit_clients/trendchip_status_diag_impl.dart';

enum NetworkUnitType {
  simulator, // TODO: vdsl simulator, adsl2+ simulator, gdmt simulator
  broadcom_telnet_adsl,
  broadcom_telnet_adslcmd,
  broadcom_telnet_adslctl,
  broadcom_telnet_xdslcmd,
  broadcom_telnet_xdslctl,
  broadcom_telnet_adsl_sh,
  broadcom_telnet_adslcmd_sh,
  broadcom_telnet_adslctl_sh,
  broadcom_telnet_xdslcmd_sh,
  broadcom_telnet_xdslctl_sh,
  @Deprecated('Use new version instead')
  trendchip_31xx_telnet,
  trendchip_telnet_status_diag,
  trendchip_telnet_perfomance,
  hg532e_http,
}

abstract class NetUnitClient {
  /// Unique snapshot ID
  String get snapshotId;

  /// Fetches line stats from the network unit
  Future<LineStats> fetchStats();

  /// Factory method for creating specific NetUnitClient implementation based on type
  factory NetUnitClient.fromType(NetworkUnitType type, String snapshotId, String ip, String login, String password) {
    switch (type) {
      case NetworkUnitType.simulator:
        return ClientSimulator(snapshotId: snapshotId);
      case NetworkUnitType.broadcom_telnet_adsl:
        return BroadcomAdslClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_adslcmd:
        return BroadcomAdslcmdClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_adslctl:
        return BroadcomAdslctlClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_xdslcmd:
        return BroadcomXdslcmdClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_xdslctl:
        return BroadcomXdslctlClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_adsl_sh:
        return BroadcomAdslShClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_adslcmd_sh:
        return BroadcomAdslcmdShClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_adslctl_sh:
        return BroadcomAdslctlShClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_xdslcmd_sh:
        return BroadcomXdslcmdShClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_telnet_xdslctl_sh:
        return BroadcomXdslctlShClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.trendchip_31xx_telnet:
        return TCP31xxClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.trendchip_telnet_status_diag:
        return TrendchipStatusDiagClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.trendchip_telnet_perfomance:
        return TrendchipPerfomanceClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      default:
        throw Exception('Unknown NetUnitClient type: $type');
    }
  }

  /// Factory method for creating specific NetUnitClient implementation based on app settings
  factory NetUnitClient.fromSettings(AppSettings settings, String snapshotId) {
    return NetUnitClient.fromType(settings.nuType, snapshotId, settings.host, settings.login, settings.pwd);
  }
}

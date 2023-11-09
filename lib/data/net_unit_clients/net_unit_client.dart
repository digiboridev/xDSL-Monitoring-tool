// ignore_for_file: constant_identifier_names

import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/bcm63xx_impl.dart';
import 'package:xdslmt/data/net_unit_clients/bcm63xx_xdslcmd_impl.dart';
import 'package:xdslmt/data/net_unit_clients/bcm63xx_xdslctl_impl.dart';
import 'package:xdslmt/data/net_unit_clients/simulator_impl.dart';
import 'package:xdslmt/data/net_unit_clients/tcp31xx_impl.dart';

enum NetworkUnitType {
  /// Mock
  simulator,

  /// Generic Broadcom BCM63xx based via telnet
  @Deprecated('new classigication')
  broadcom_63xx_telnet,

  /// Generic Broadcom BCM63xx (VDSL+) based via telnet
  /// usually usses xdslcmd instead of adsl
  @Deprecated('new classigication')
  broadcom_63xx_xdslcmd_telnet,

  /// Generic Broadcom BCM63xx (VDSL+) based via telnet
  /// usually usses xdslctl instead of adsl
  @Deprecated('new classigication')
  broadcom_63xx_xdslctl_telnet,

  // Generic Trendchip(Ralink, MTK) based via telnet
  trendchip_31xx_telnet,

  /// ZTE H108n v1 via telnet
  h108nv1_telnet,

  /// TP-Link w8901 via telnet
  w8901_telnet,

  /// D-Link 2640u via telnet
  d2640u_telnet,

  /// Tenda d301 via telnet
  d301_telnet,

  /// Huawei HG532e via http
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
      case NetworkUnitType.broadcom_63xx_telnet:
        return BCM63xxClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_63xx_xdslcmd_telnet:
        return BCM63xdslcmdClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.broadcom_63xx_xdslctl_telnet:
        return BCM63xdslctlClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      case NetworkUnitType.trendchip_31xx_telnet:
        return TCP31xxClientImpl(unitIp: ip, snapshotId: snapshotId, login: login, password: password);
      default:
        throw Exception('Unknown NetUnitClient type: $type');
    }
  }

  /// Factory method for creating specific NetUnitClient implementation based on app settings
  factory NetUnitClient.fromSettings(AppSettings settings, String snapshotId) {
    return NetUnitClient.fromType(settings.nuType, snapshotId, settings.host, settings.login, settings.pwd);
  }
}

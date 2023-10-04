// ignore_for_file: constant_identifier_names

/// Network unit parser types
enum NetworkUnitType {
  /// Mock
  simulator,

  /// Huawei HG532e via http
  hg532e_http,

  /// ZTE H108n v1 via telnet
  h108nv1_telnet,

  /// TP-Link w8901 via telnet
  w8901_telnet,

  /// D-Link 2640u via telnet
  d2640u_telnet,

  /// Tenda d301 via telnet
  d301_telnet,
}

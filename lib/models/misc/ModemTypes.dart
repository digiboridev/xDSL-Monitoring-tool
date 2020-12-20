import 'package:hive/hive.dart';

part 'ModemTypes.g.dart';

@HiveType(typeId: 40)
enum ModemTypes {
  @HiveField(1)
  Client_simulation,

  @HiveField(2)
  ZTE_H108n_v1_via_telnet,

  @HiveField(3)
  TPLink_w8901_via_telnet,

  @HiveField(4)
  Huawei_HG532e
}

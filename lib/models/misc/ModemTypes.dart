import 'package:hive/hive.dart';

part 'ModemTypes.g.dart';

@HiveType(typeId: 40)
enum ModemTypes {
  @HiveField(0)
  Huawei_HG532e,

  @HiveField(1)
  Dlink_2640u,

  @HiveField(2)
  ZTE_h108n,

  @HiveField(3)
  Tebda_D301
}

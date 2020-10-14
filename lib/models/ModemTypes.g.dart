// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModemTypes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModemTypesAdapter extends TypeAdapter<ModemTypes> {
  @override
  final int typeId = 40;

  @override
  ModemTypes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ModemTypes.Huawei_HG532e;
      case 1:
        return ModemTypes.Dlink_2640u;
      case 2:
        return ModemTypes.ZTE_h108n;
      case 3:
        return ModemTypes.Tebda_D301;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ModemTypes obj) {
    switch (obj) {
      case ModemTypes.Huawei_HG532e:
        writer.writeByte(0);
        break;
      case ModemTypes.Dlink_2640u:
        writer.writeByte(1);
        break;
      case ModemTypes.ZTE_h108n:
        writer.writeByte(2);
        break;
      case ModemTypes.Tebda_D301:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModemTypesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

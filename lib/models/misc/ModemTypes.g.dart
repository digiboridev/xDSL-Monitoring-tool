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
        return ModemTypes.ZTE_H108n_v1_via_telnet;
      case 4:
        return ModemTypes.TPLink_w8901_via_telnet;
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
      case ModemTypes.ZTE_H108n_v1_via_telnet:
        writer.writeByte(1);
        break;
      case ModemTypes.TPLink_w8901_via_telnet:
        writer.writeByte(4);
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Some.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SomeAdapter extends TypeAdapter<Some> {
  @override
  final int typeId = 12;

  @override
  Some read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Some();
  }

  @override
  void write(BinaryWriter writer, Some obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.String);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SomeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

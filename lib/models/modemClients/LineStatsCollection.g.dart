// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LineStatsCollection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LineStatsCollectionAdapter extends TypeAdapter<LineStatsCollection> {
  @override
  final int typeId = 30;

  @override
  LineStatsCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LineStatsCollection(
      isConnectionUp: fields[0] as bool,
      status: fields[1] as String,
      connectionType: fields[2] as String,
      upMaxRate: fields[3] as int,
      downMaxRate: fields[4] as int,
      upRate: fields[5] as int,
      downRate: fields[6] as int,
      upMargin: fields[7] as double,
      downMargin: fields[8] as double,
      upAttenuation: fields[9] as double,
      downAttenuation: fields[10] as double,
      upCRC: fields[11] as int,
      downCRC: fields[12] as int,
      upFEC: fields[13] as int,
      downFEC: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LineStatsCollection obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.isConnectionUp)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.connectionType)
      ..writeByte(3)
      ..write(obj.upMaxRate)
      ..writeByte(4)
      ..write(obj.downMaxRate)
      ..writeByte(5)
      ..write(obj.upRate)
      ..writeByte(6)
      ..write(obj.downRate)
      ..writeByte(7)
      ..write(obj.upMargin)
      ..writeByte(8)
      ..write(obj.downMargin)
      ..writeByte(9)
      ..write(obj.upAttenuation)
      ..writeByte(10)
      ..write(obj.downAttenuation)
      ..writeByte(11)
      ..write(obj.upCRC)
      ..writeByte(12)
      ..write(obj.downCRC)
      ..writeByte(13)
      ..write(obj.upFEC)
      ..writeByte(14)
      ..write(obj.downFEC)
      ..writeByte(15)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineStatsCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

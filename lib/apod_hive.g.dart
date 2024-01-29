// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apod_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApodHiveAdapter extends TypeAdapter<ApodHive> {
  @override
  final int typeId = 0;

  @override
  ApodHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApodHive(
      date: fields[0] as String,
      explanation: fields[1] as String,
      title: fields[2] as String,
      url: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApodHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.explanation)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApodHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

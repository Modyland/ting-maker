// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_polygon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainPolygonAdapter extends TypeAdapter<MainPolygon> {
  @override
  final int typeId = 2;

  @override
  MainPolygon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainPolygon(
      gisCode: fields[0] as String,
      location: (fields[1] as List).cast<NLatLng>(),
    );
  }

  @override
  void write(BinaryWriter writer, MainPolygon obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.gisCode)
      ..writeByte(1)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainPolygonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

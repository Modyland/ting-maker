// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 1;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      idx: fields[0] as num,
      id: fields[1] as String,
      phone: fields[2] as String,
      birth: fields[3] as String,
      gender: fields[4] as String,
      visible: fields[5] as int,
      imgupDate: fields[6] as String,
      aka: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idx)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.birth)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.visible)
      ..writeByte(6)
      ..write(obj.imgupDate)
      ..writeByte(7)
      ..write(obj.aka);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

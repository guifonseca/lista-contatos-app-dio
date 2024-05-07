// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contato_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContatoModelAdapter extends TypeAdapter<ContatoModel> {
  @override
  final int typeId = 0;

  @override
  ContatoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContatoModel()
      .._id = fields[0] as String
      .._nome = fields[1] as String
      .._telefone = fields[2] as String
      .._email = fields[3] as String
      .._dataNascimento = fields[4] as DateTime?
      .._photoLocation = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, ContatoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._nome)
      ..writeByte(2)
      ..write(obj._telefone)
      ..writeByte(3)
      ..write(obj._email)
      ..writeByte(4)
      ..write(obj._dataNascimento)
      ..writeByte(5)
      ..write(obj._photoLocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContatoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

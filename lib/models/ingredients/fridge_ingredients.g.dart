// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fridge_ingredients.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FridgeIngredientAdapter extends TypeAdapter<FridgeIngredient> {
  @override
  final int typeId = 2;

  @override
  FridgeIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FridgeIngredient(
      name: fields[0] as String,
      quantity: fields[1] as String,
      imgPath: fields[2] as String,
      expirationDate: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FridgeIngredient obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.imgPath)
      ..writeByte(3)
      ..write(obj.expirationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FridgeIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

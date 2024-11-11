// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_ingredients.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BasketIngredientAdapter extends TypeAdapter<BasketIngredient> {
  @override
  final int typeId = 1;

  @override
  BasketIngredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasketIngredient(
      name: fields[0] as String,
      isSelected: fields[1] as bool,
      quantity: fields[2] as String,
      unit: fields[3] as String,
      imageUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BasketIngredient obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.isSelected)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasketIngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

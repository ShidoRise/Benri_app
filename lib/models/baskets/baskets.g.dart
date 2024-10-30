// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baskets.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BasketAdapter extends TypeAdapter<Basket> {
  @override
  final int typeId = 0;

  @override
  Basket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Basket(
      date: fields[0] as String,
      basketIngredients: (fields[1] as List).cast<BasketIngredient>(),
      totalMoney: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Basket obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.basketIngredients)
      ..writeByte(2)
      ..write(obj.totalMoney);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

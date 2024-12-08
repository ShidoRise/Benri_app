// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fridge_drawers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FridgeDrawerAdapter extends TypeAdapter<FridgeDrawer> {
  @override
  final int typeId = 5;

  @override
  FridgeDrawer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FridgeDrawer(
      name: fields[0] as String,
      fridgeIngredients: (fields[1] as List).cast<FridgeIngredient>(),
    );
  }

  @override
  void write(BinaryWriter writer, FridgeDrawer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.fridgeIngredients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FridgeDrawerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

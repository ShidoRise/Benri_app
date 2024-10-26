// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_suggestions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientSuggestionAdapter extends TypeAdapter<IngredientSuggestion> {
  @override
  final int typeId = 1;

  @override
  IngredientSuggestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientSuggestion(
      name: fields[0] as String,
      thumbnailUrl: fields[1] as String,
      nameInVietnamese: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientSuggestion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.thumbnailUrl)
      ..writeByte(2)
      ..write(obj.nameInVietnamese);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientSuggestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

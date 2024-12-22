// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipesAdapter extends TypeAdapter<Recipes> {
  @override
  final int typeId = 4;

  @override
  Recipes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipes(
      name: fields[0] as String,
      description: fields[1] as String,
      imgPath: fields[2] as String,
      rating: fields[3] as String,
      timeCooking: fields[4] as String,
      ingredients: (fields[5] as List).cast<FridgeIngredient>(),
      category: fields[6] as String,
      recipeYoutubeUrl: fields[7] as String,
    )..isFavorite = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, Recipes obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imgPath)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.timeCooking)
      ..writeByte(5)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.recipeYoutubeUrl)
      ..writeByte(8)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

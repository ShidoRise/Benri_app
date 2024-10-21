import 'package:hive/hive.dart';

part 'ingredients.g.dart'; // This will generate the adapter

@HiveType(typeId: 0)
class Ingredient {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isSelected;

  Ingredient({required this.name, this.isSelected = false});

  // Convert Ingredient to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isSelected': isSelected,
    };
  }

  // Create Ingredient from Map
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      isSelected: map['isSelected'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Ingredient{name: $name, isSelected: $isSelected}';
  }
}

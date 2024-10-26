import 'package:hive/hive.dart';

part 'ingredients.g.dart'; // This will generate the adapter

@HiveType(typeId: 0)
class Ingredient {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isSelected;

  @HiveField(2)
  String quantity; // New field for quantity

  @HiveField(3)
  String unit; // New field for unit

  @HiveField(4)
  String imageUrl; // New field for image URL (nullable)

  Ingredient({
    required this.name,
    this.isSelected = false,
    this.quantity = '',
    this.unit = '',
    this.imageUrl = '',
  });

  // Convert Ingredient to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isSelected': isSelected,
      'quantity': quantity,
      'unit': unit,
      'imageUrl': imageUrl,
    };
  }

  // Create Ingredient from Map
  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      isSelected: map['isSelected'] ?? false,
      quantity: map['quantity'] ?? '',
      unit: map['unit'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  @override
  String toString() {
    return 'Ingredient{name: $name, isSelected: $isSelected, quantity: $quantity, unit: $unit, imageUrl: $imageUrl}';
  }
}

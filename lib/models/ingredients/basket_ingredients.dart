import 'package:hive/hive.dart';

part 'basket_ingredients.g.dart';

@HiveType(typeId: 0)
class BasketIngredient {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isSelected;

  @HiveField(2)
  String quantity;

  @HiveField(3)
  String unit;

  @HiveField(4)
  String imageUrl;

  BasketIngredient({
    required this.name,
    this.isSelected = false,
    this.quantity = '',
    this.unit = '',
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isSelected': isSelected,
      'quantity': quantity,
      'unit': unit,
      'imageUrl': imageUrl,
    };
  }

  factory BasketIngredient.fromMap(Map<String, dynamic> map) {
    return BasketIngredient(
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

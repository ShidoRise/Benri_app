import 'package:hive/hive.dart';

part 'fridge_ingredients.g.dart';

@HiveType(typeId: 2)
class FridgeIngredient {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String quantity;

  @HiveField(2)
  final String imgPath;

  @HiveField(3)
  final DateTime? expirationDate;

  FridgeIngredient({
    required this.name,
    required this.quantity,
    required this.imgPath,
    this.expirationDate,
  });

  factory FridgeIngredient.fromMap(Map<String, dynamic> map) {
    return FridgeIngredient(
      name: map['name'],
      quantity: map['quantity'] ?? '',
      imgPath: map['imgPath'] ?? '',
      expirationDate: map['expirationDate'] ?? '',
    );
  }

  bool isExpired() {
    return DateTime.now().isAfter(expirationDate!);
  }

  @override
  String toString() {
    return 'FridgeIngredient{name: $name, quantity: $quantity, imagePath: $imgPath, expirationDate: $expirationDate}';
  }
}

class FamilyIngredient {
  String name;
  String quantity;
  String category;
  String unit;
  bool status;

  FamilyIngredient({
    required this.name,
    required this.quantity,
    required this.category,
    required this.unit,
    required this.status,
  });

  factory FamilyIngredient.fromJson(Map<String, dynamic> json) {
    return FamilyIngredient(
      name: json['name'] ?? '',
      quantity: json['quantity']?.toString() ?? '',
      category: json['category'] ?? '',
      unit: json['unit'] ?? '',
      status: json['status'] == 'bought',
    );
  }

  @override
  String toString() {
    return 'FamilyIngredient(name: $name, quantity: $quantity, category: $category, unit: $unit, status: $status)';
  }
}

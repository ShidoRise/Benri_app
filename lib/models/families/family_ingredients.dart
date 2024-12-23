class FamilyIngredient {
  final String name;
  final double quantity;
  final String category;
  final String unit;
  final bool status;

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
      quantity: (json['quantity'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      unit: json['unit'] ?? '',
      status: json['status'] ?? false,
    );
  }

  @override
  String toString() {
    return 'FamilyIngredient(name: $name, quantity: $quantity, category: $category, unit: $unit, status: $status)';
  }
}

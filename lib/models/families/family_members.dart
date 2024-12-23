class FamilyMember {
  final String id;
  final String name;
  final String role;

  FamilyMember({
    required this.id,
    required this.name,
    required this.role,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final userId = json['userId'];
    return FamilyMember(
      id: userId['id'] ?? '',
      name: userId['name'] ?? '',
      role: userId['role'] ?? '',
    );
  }

  @override
  String toString() {
    return 'FamilyMember(id: $id, name: $name, role: $role)';
  }
}

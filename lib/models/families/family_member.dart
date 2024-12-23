class FamilyMember {
  final String userId;
  final String role;

  FamilyMember({required this.userId, required this.role});

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      userId: json['userId'],
      role: json['role'],
    );
  }
}

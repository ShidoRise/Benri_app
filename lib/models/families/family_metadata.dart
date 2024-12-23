import 'package:benri_app/models/families/family_member.dart';

class FamilyMetadata {
  final String famName;
  final List<FamilyMember> famMembers;
  final String createdBy;
  final String code;
  final String createdAt;
  final String updatedAt;
  final String familyId;

  FamilyMetadata({
    required this.famName,
    required this.famMembers,
    required this.createdBy,
    required this.code,
    required this.familyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FamilyMetadata.fromJson(Map<String, dynamic> json) {
    return FamilyMetadata(
      famName: json['fam_name'],
      famMembers: (json['fam_members'] as List)
          .map((member) => FamilyMember.fromJson(member))
          .toList(),
      createdBy: json['created_by'],
      code: json['code'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      familyId: json['family_id'],
    );
  }
}

import 'package:benri_app/models/families/family_metadata.dart';

class FamilyResponse {
  final String message;
  final int status;
  final FamilyMetadata metadata;

  FamilyResponse({
    required this.message,
    required this.status,
    required this.metadata,
  });

  factory FamilyResponse.fromJson(Map<String, dynamic> json) {
    return FamilyResponse(
      message: json['message'],
      status: json['status'],
      metadata: FamilyMetadata.fromJson(json['metadata']),
    );
  }
}

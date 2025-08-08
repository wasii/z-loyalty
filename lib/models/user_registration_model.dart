class UserRegistrationModel {
  final int error;
  final String message;
  final int installationId;

  UserRegistrationModel({
    required this.error,
    required this.message,
    required this.installationId,
  });

  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) {
    return UserRegistrationModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
      installationId: int.tryParse(json['installation_id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'installation_id': installationId,
    };
  }
}

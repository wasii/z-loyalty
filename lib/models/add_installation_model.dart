class AddInstallationModel {
  final int error;
  final String message;
  final int installation_id;

  AddInstallationModel({
    required this.error,
    required this.message,
    required this.installation_id,
  });

  factory AddInstallationModel.fromJson(Map<String, dynamic> json) {
    return AddInstallationModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
      installation_id: int.tryParse(json['installation_id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'installation_id': installation_id,
    };
  }
}

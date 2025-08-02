// ignore_for_file: non_constant_identifier_names

class ForgotPasswrodModel {
  final int error;
  final String message;

  ForgotPasswrodModel({required this.error, required this.message});

  factory ForgotPasswrodModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswrodModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }
}

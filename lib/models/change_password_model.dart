class ChangePasswordModel {
  final int error;
  final String message;

  ChangePasswordModel({required this.error, required this.message});

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }
}

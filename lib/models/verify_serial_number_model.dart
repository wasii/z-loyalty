class VerifySerialNumberModel {
  final int error;
  final String message;

  VerifySerialNumberModel({required this.error, required this.message});

  factory VerifySerialNumberModel.fromJson(Map<String, dynamic> json) {
    return VerifySerialNumberModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }
}

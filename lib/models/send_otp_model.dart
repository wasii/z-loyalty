// ignore_for_file: non_constant_identifier_names

class SendOTPModel {
  final int error;
  final String message;
  final int send_otp;

  SendOTPModel({
    required this.error,
    required this.message,
    required this.send_otp,
  });

  factory SendOTPModel.fromJson(Map<String, dynamic> json) {
    return SendOTPModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
      send_otp:
          int.tryParse(json['sent_otp'].toString()) ?? 0, //['sent_otp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message, 'sent_otp': send_otp};
  }
}

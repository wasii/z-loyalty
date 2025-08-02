class CheckUsernameModel {
  final int error;
  final String message;

  CheckUsernameModel({required this.error, required this.message});

  factory CheckUsernameModel.fromJson(Map<String, dynamic> json) {
    return CheckUsernameModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }
}

class ClaimRewardModel {
  final int error;
  final String message;

  ClaimRewardModel({required this.error, required this.message});

  factory ClaimRewardModel.fromJson(Map<String, dynamic> json) {
    return ClaimRewardModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }
}

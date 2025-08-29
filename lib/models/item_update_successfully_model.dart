class ItemUpdateSuccessfullyModel {
  final int error;
  final String message;

  ItemUpdateSuccessfullyModel({required this.error, required this.message});

  factory ItemUpdateSuccessfullyModel.fromJson(Map<String, dynamic> json) {
    return ItemUpdateSuccessfullyModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }
}

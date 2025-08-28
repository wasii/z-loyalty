class DeleteSingleImageFileModel {
  final int error;
  final String message;

  DeleteSingleImageFileModel({required this.error, required this.message});

  factory DeleteSingleImageFileModel.fromJson(Map<String, dynamic> json) {
    return DeleteSingleImageFileModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }
}

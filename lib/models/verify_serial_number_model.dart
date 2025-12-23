class VerifySerialNumberModel {
  final int error;
  final String message;
  final int? isSystemSerial;
  final String? itemId;

  VerifySerialNumberModel({
    required this.error,
    required this.message,
    this.isSystemSerial,
    this.itemId,
  });

  factory VerifySerialNumberModel.fromJson(Map<String, dynamic> json) {
    return VerifySerialNumberModel(
      error: int.tryParse(json['error']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      isSystemSerial: int.tryParse(json['is_system_serial']?.toString() ?? '0'),
      itemId: json['item_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      if (isSystemSerial != null) 'is_system_serial': isSystemSerial,
      if (itemId != null) 'item_id': itemId,
    };
  }
}

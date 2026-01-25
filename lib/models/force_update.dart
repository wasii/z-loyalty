class ForeceUpdateModel {
  final bool isForce;

  ForeceUpdateModel({required this.isForce});

  factory ForeceUpdateModel.fromJson(Map<String, dynamic> json) {
    // Handle boolean value - json['isForce'] is already a boolean, not a string
    final isForceValue = json['isForce'];
    bool isForceBool = false;
    if (isForceValue is bool) {
      isForceBool = isForceValue;
    } else if (isForceValue is String) {
      isForceBool = isForceValue.toLowerCase() == 'true';
    } else if (isForceValue is int) {
      isForceBool = isForceValue == 1;
    }
    return ForeceUpdateModel(isForce: isForceBool);
  }

  Map<String, dynamic> toJson() {
    return {'isForce': isForce};
  }
}

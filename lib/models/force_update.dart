class ForeceUpdateModel {
  final bool isForce;
  final String iosurl;
  final String androidurl;

  ForeceUpdateModel({
    required this.isForce,
    required this.iosurl,
    required this.androidurl,
  });

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
    return ForeceUpdateModel(
      isForce: isForceBool,
      iosurl: json['iosurl'] as String? ?? '',
      androidurl: json['androidurl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'isForce': isForce, 'iosurl': iosurl, 'androidurl': androidurl};
  }
}

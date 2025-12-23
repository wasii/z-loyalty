class SchemeDetail {
  final String itemName;
  final String minPoints;
  final String picUrl;
  final String claimUrl;

  SchemeDetail({
    required this.itemName,
    required this.minPoints,
    required this.picUrl,
    required this.claimUrl,
  });

  factory SchemeDetail.fromJson(Map<String, dynamic> json) {
    return SchemeDetail(
      itemName: json['item_name'] ?? '',
      minPoints: json['min_points'] ?? '0',
      picUrl: json['pic_url'] ?? '',
      claimUrl: json['claim_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'min_points': minPoints,
      'pic_url': picUrl,
      'claim_url': claimUrl,
    };
  }
}

class DashboardPointsModel {
  final int error;
  final String myCurrentAvailablePoints;
  final List<SchemeDetail> schemeDetails;

  DashboardPointsModel({
    required this.error,
    required this.myCurrentAvailablePoints,
    required this.schemeDetails,
  });

  factory DashboardPointsModel.fromJson(Map<String, dynamic> json) {
    return DashboardPointsModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      myCurrentAvailablePoints: json['my_current_available_points'] ?? '0',
      schemeDetails:
          (json['scheme_details'] as List<dynamic>?)
              ?.map(
                (item) => SchemeDetail.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'my_current_available_points': myCurrentAvailablePoints,
      'scheme_details': schemeDetails.map((item) => item.toJson()).toList(),
    };
  }
}

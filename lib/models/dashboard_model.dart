class DashboardPointsModel {
  final int error;
  final String myCurrentAvailablePoints;
  final List<String> links;

  DashboardPointsModel({
    required this.error,
    required this.myCurrentAvailablePoints,
    required this.links,
  });

  factory DashboardPointsModel.fromJson(Map<String, dynamic> json) {
    return DashboardPointsModel(
      error: int.tryParse(json['error'].toString()) ?? 0,
      myCurrentAvailablePoints: json['my_current_available_points'] ?? '0',
      links: List<String>.from(json['links'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'my_current_available_points': myCurrentAvailablePoints,
      'links': links,
    };
  }
}

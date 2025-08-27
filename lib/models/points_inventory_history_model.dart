class PointsInventoryHistoryResponse {
  final int error;
  final List<PointsInventoryHistoryData> pointsInventoryHistory;

  PointsInventoryHistoryResponse({
    required this.error,
    required this.pointsInventoryHistory,
  });

  factory PointsInventoryHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PointsInventoryHistoryResponse(
      error: int.tryParse(json['error'].toString()) ?? 0,
      pointsInventoryHistory:
          (json['points_inventory_history'] as List<dynamic>?)
              ?.map((e) => PointsInventoryHistoryData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'points_inventory_history': pointsInventoryHistory
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class PointsInventoryHistoryData {
  final String date;
  final String inventoryType;
  final int points;
  final String details;
  final bool? isBlocked;

  PointsInventoryHistoryData({
    required this.date,
    required this.inventoryType,
    required this.points,
    required this.details,
    this.isBlocked,
  });

  factory PointsInventoryHistoryData.fromJson(Map<String, dynamic> json) {
    return PointsInventoryHistoryData(
      date: json['date'] ?? '',
      inventoryType: json['inventory_type'] ?? '',
      points: int.tryParse(json['points'].toString()) ?? 0,
      details: json['details'] ?? '',
      isBlocked: json['is_blocked'] == null
          ? null
          : json['is_blocked'].toString() == "1",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'inventory_type': inventoryType,
      'points': points,
      'details': details,
      'is_blocked': isBlocked == null
          ? null
          : (isBlocked! ? "1" : "0"), // wapas string "0"/"1"
    };
  }
}

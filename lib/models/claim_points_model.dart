class InstallationClaimsResponse {
  final int error;
  final bool showCash;
  final bool showBike;
  final bool showUmrah;
  final List<InstallationClaim> installationClaims;

  InstallationClaimsResponse({
    required this.error,
    required this.showCash,
    required this.showBike,
    required this.showUmrah,
    required this.installationClaims,
  });

  factory InstallationClaimsResponse.fromJson(Map<String, dynamic> json) {
    return InstallationClaimsResponse(
      error: int.tryParse(json['error'].toString()) ?? 0,
      showCash: (int.tryParse(json['show_cash'].toString()) ?? 0) == 1,
      showBike: (int.tryParse(json['show_bike'].toString()) ?? 0) == 1,
      showUmrah: (int.tryParse(json['show_umrah'].toString()) ?? 0) == 1,
      installationClaims:
          (json['installation_claims'] as List<dynamic>?)
              ?.map((e) => InstallationClaim.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'show_cash': showCash ? 1 : 0,
      'show_bike': showBike ? 1 : 0,
      'show_umrah': showUmrah ? 1 : 0,
      'installation_claims': installationClaims.map((e) => e.toJson()).toList(),
    };
  }
}

class InstallationClaim {
  final int installationId;
  final int installerId;
  final String serialNumber;
  final String itemInstalled;
  final int pointsEarned;

  InstallationClaim({
    required this.installationId,
    required this.installerId,
    required this.serialNumber,
    required this.itemInstalled,
    required this.pointsEarned,
  });

  factory InstallationClaim.fromJson(Map<String, dynamic> json) {
    return InstallationClaim(
      installationId: int.tryParse(json['installation_id'].toString()) ?? 0,
      installerId: int.tryParse(json['installer_id'].toString()) ?? 0,
      serialNumber: json['serial_number'] ?? '',
      itemInstalled: json['item_installed'] ?? '',
      pointsEarned: int.tryParse(json['points_earned'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installation_id': installationId,
      'installer_id': installerId,
      'serial_number': serialNumber,
      'item_installed': itemInstalled,
      'points_earned': pointsEarned,
    };
  }
}

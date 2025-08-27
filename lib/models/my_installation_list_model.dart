class MyProductsInstallationsResponse {
  final int error;
  final List<MyProductsInstallation> installations;

  MyProductsInstallationsResponse({
    required this.error,
    required this.installations,
  });

  factory MyProductsInstallationsResponse.fromJson(Map<String, dynamic> json) {
    return MyProductsInstallationsResponse(
      error: int.tryParse(json['error'].toString()) ?? 0,
      installations:
          (json['installations'] as List<dynamic>?)
              ?.map((e) => MyProductsInstallation.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'installations': installations.map((e) => e.toJson()).toList(),
    };
  }
}

class MyProductsInstallation {
  final String installationId;
  final String installerId;
  final String serialNumber;
  final String clientName;
  final String clientMobile;
  final String installationCity;
  final String itemInstalled;
  final int pointsEarned;
  final String installationAddress;
  final List<MyProductsUploadPic> uploadPics;
  final bool isApproved;
  final bool isClaimed;
  final bool isBlocked;
  final bool isRewarded;

  MyProductsInstallation({
    required this.installationId,
    required this.installerId,
    required this.serialNumber,
    required this.clientName,
    required this.clientMobile,
    required this.installationCity,
    required this.itemInstalled,
    required this.pointsEarned,
    required this.installationAddress,
    required this.uploadPics,
    required this.isApproved,
    required this.isClaimed,
    required this.isBlocked,
    required this.isRewarded,
  });

  factory MyProductsInstallation.fromJson(Map<String, dynamic> json) {
    return MyProductsInstallation(
      installationId: json['installation_id'] ?? '',
      installerId: json['installer_id'] ?? '',
      serialNumber: json['serial_number'] ?? '',
      clientName: json['client_name'] ?? '',
      clientMobile: json['client_mobile'] ?? '',
      installationCity: json['installation_city'] ?? '',
      itemInstalled: json['item_installed'] ?? '',
      pointsEarned: int.tryParse(json['points_earned'].toString()) ?? 0,
      installationAddress: json['installation_address'] ?? '',
      uploadPics:
          (json['upload_pics'] as List<dynamic>?)
              ?.map((e) => MyProductsUploadPic.fromJson(e))
              .toList() ??
          [],
      isApproved: json['is_approved'].toString() == "1",
      isClaimed: json['is_claimed'].toString() == "1",
      isBlocked: json['is_blocked'].toString() == "1",
      isRewarded: json['is_rewarded'].toString() == "1",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installation_id': installationId,
      'installer_id': installerId,
      'serial_number': serialNumber,
      'client_name': clientName,
      'client_mobile': clientMobile,
      'installation_city': installationCity,
      'item_installed': itemInstalled,
      'points_earned': pointsEarned,
      'installation_address': installationAddress,
      'upload_pics': uploadPics.map((e) => e.toJson()).toList(),
      'is_approved': isApproved ? "1" : "0",
      'is_claimed': isClaimed ? "1" : "0",
      'is_blocked': isBlocked ? "1" : "0",
      'is_rewarded': isRewarded ? "1" : "0",
    };
  }
}

class MyProductsUploadPic {
  final String link;
  final String linkThumbnail;
  final String filePath;

  MyProductsUploadPic({
    required this.link,
    required this.linkThumbnail,
    required this.filePath,
  });

  factory MyProductsUploadPic.fromJson(Map<String, dynamic> json) {
    return MyProductsUploadPic(
      link: json['link'] ?? '',
      linkThumbnail: json['link_thumbnail'] ?? '',
      filePath: json['file_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'link_thumbnail': linkThumbnail,
      'file_path': filePath,
    };
  }
}

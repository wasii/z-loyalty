class UserModel {
  final String id;
  final String name;
  final String contactNos;
  final String whatsappNo;
  final String email;
  final String username;
  final String city;
  final String experienceInYears;
  final String visitingCardPic;
  final String address;
  final String easyPaisaDetails;
  final String jazzCashDetails;
  final String bankAccountDetails;
  final int error;
  final String message;

  UserModel({
    required this.id,
    required this.name,
    required this.contactNos,
    required this.whatsappNo,
    required this.email,
    required this.username,
    required this.city,
    required this.experienceInYears,
    required this.visitingCardPic,
    required this.address,
    required this.easyPaisaDetails,
    required this.jazzCashDetails,
    required this.bankAccountDetails,
    required this.error,
    required this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      contactNos: json['contact_nos'] ?? '',
      whatsappNo: json['whatsapp_no'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      city: json['city'] ?? '',
      experienceInYears: json['experience_in_years'] ?? '',
      visitingCardPic: json['visiting_card_pic'] ?? '',
      address: json['address'] ?? '',
      easyPaisaDetails: json['easy_paisa_details'] ?? '',
      jazzCashDetails: json['jazz_cash_details'] ?? '',
      bankAccountDetails: json['bank_account_details'] ?? '',
      error: int.tryParse(json['error'].toString()) ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact_nos': contactNos,
      'whatsapp_no': whatsappNo,
      'email': email,
      'username': username,
      'city': city,
      'experience_in_years': experienceInYears,
      'visiting_card_pic': visitingCardPic,
      'address': address,
      'easy_paisa_details': easyPaisaDetails,
      'jazz_cash_details': jazzCashDetails,
      'bank_account_details': bankAccountDetails,
      'error': error,
      'message': message,
    };
  }
}

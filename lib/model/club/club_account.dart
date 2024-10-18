class ClubAccount {
  String clubAccountBankName;
  String clubAccountNumber;
  String? clubAccountPinTechNumber;

  ClubAccount({
    required this.clubAccountBankName,
    required this.clubAccountNumber,
    this.clubAccountPinTechNumber,
  });

  ClubAccount copyWith({
    String? clubAccountBankName,
    String? clubAccountNumber,
    String? clubAccountPinTechNumber,
  }) {
    return ClubAccount(
      clubAccountBankName: clubAccountBankName ?? this.clubAccountBankName,
      clubAccountNumber: clubAccountNumber ?? this.clubAccountNumber,
      clubAccountPinTechNumber: clubAccountPinTechNumber ?? this.clubAccountPinTechNumber,
    );
  }

  factory ClubAccount.fromJson(Map<String, dynamic> json) {
    return ClubAccount(
      clubAccountBankName: json['clubAccountBankName'],
      clubAccountNumber: json['clubAccountNumber'],
      clubAccountPinTechNumber: json['clubAccountPinTechNumber'],
    );
  }

  Map<String, dynamic> toJsonForValidation() {
    return {
      'clubAccountBankName': clubAccountBankName,
      'clubAccountNumber': clubAccountNumber,
    };
  }

  Map<String, dynamic> toJsonForRegister() {
    return {
      'clubAccountBankName': clubAccountBankName,
      'clubAccountNumber': clubAccountNumber,
      'clubAccountPinTechNumber': clubAccountPinTechNumber,
    };
  }
}

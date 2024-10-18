class Member {
  final String memberSchool;
  final String memberEmail;
  final String memberName;
  String? memberPhoneNumber;
  String? memberMajor;
  String? memberGender;
  String? memberStudentNumber;

  Member({
    required this.memberSchool,
    required this.memberEmail,
    required this.memberName,
    this.memberPhoneNumber,
    this.memberMajor,
    this.memberGender,
    this.memberStudentNumber,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberSchool: json['memberSchool'],
      memberEmail: json['memberEmail'],
      memberName: json['memberName'],
      memberPhoneNumber: json['memberPhoneNumber'],
      memberMajor: json['memberMajor'],
      memberGender: json['memberGender'],
      memberStudentNumber: json['memberStudentNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberPhoneNumber': memberPhoneNumber,
      'memberMajor': memberMajor,
      'memberGender': memberGender,
      'memberStudentNumber': memberStudentNumber,
    };
  }
}

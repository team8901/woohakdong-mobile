class Group {
  int? groupId;
  String? groupName;
  String? groupLink;
  String? groupDescription;
  int? groupAmount;

  Group({
    this.groupId,
    this.groupName,
    this.groupLink,
    this.groupDescription,
    this.groupAmount,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      groupName: json['groupName'],
      groupLink: json['groupLink'],
      groupDescription: json['groupDescription'],
      groupAmount: json['groupAmount'],
    );
  }
}

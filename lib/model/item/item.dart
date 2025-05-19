class Item {
  int? itemId;
  String? itemName;
  String? itemPhoto;
  String? itemDescription;
  String? itemLocation;
  String? itemCategory;
  int? itemRentalMaxDay;
  bool? itemAvailable;
  bool? itemUsing;
  DateTime? itemRentalDate;
  int? itemRentalTime;
  String? memberName;
  bool? itemOverdue;

  Item({
    this.itemId,
    this.itemName,
    this.itemPhoto,
    this.itemDescription,
    this.itemLocation,
    this.itemCategory,
    this.itemRentalMaxDay,
    this.itemAvailable,
    this.itemUsing,
    this.itemRentalDate,
    this.itemRentalTime,
    this.memberName,
    this.itemOverdue,
  });

  Item copyWith({
    int? itemId,
    String? itemName,
    String? itemPhoto,
    String? itemDescription,
    String? itemLocation,
    String? itemCategory,
    int? itemRentalMaxDay,
  }) {
    return Item(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      itemPhoto: itemPhoto ?? this.itemPhoto,
      itemDescription: itemDescription ?? this.itemDescription,
      itemLocation: itemLocation ?? this.itemLocation,
      itemCategory: itemCategory ?? this.itemCategory,
      itemRentalMaxDay: itemRentalMaxDay ?? this.itemRentalMaxDay,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json, bool isList) {
    String? thumbnail = json['itemPhoto'];

    if (thumbnail != null && thumbnail.contains('/images/')) {
      thumbnail = thumbnail.replaceAll('/images/', '/thumbnail/');
    }

    return Item(
      itemId: json['itemId'],
      itemName: json['itemName'],
      itemPhoto: isList ? thumbnail : json['itemPhoto'],
      itemDescription: json['itemDescription'],
      itemLocation: json['itemLocation'],
      itemCategory: json['itemCategory'],
      itemRentalMaxDay: json['itemRentalMaxDay'],
      itemAvailable: json['itemAvailable'],
      itemUsing: json['itemUsing'],
      itemRentalDate: json['itemRentalDate'] != null ? DateTime.parse(json['itemRentalDate']) : null,
      itemRentalTime: json['itemRentalTime'],
      memberName: json['memberName'],
      itemOverdue: json['itemOverdue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'itemPhoto': itemPhoto,
      'itemDescription': itemDescription,
      'itemLocation': itemLocation,
      'itemCategory': itemCategory,
      'itemRentalMaxDay': itemRentalMaxDay,
    };
  }
}

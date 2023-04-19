class WishList {
  String dateTime;
  String wish;
  bool status;

  WishList({required this.dateTime, required this.wish, required this.status});

  WishList.fromJson(Map<dynamic, dynamic> json)
      : dateTime = json['dateTime'] as String,
        wish = json['wish'] as String,
        status = json['status'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'dateTime': dateTime,
    'wish': wish,
    'status': status,
  };

  Map<String, dynamic> toMap() => <String, dynamic>{
    'dateTime': dateTime,
    'wish': wish,
    'status': status,
  };

  String getWishList()=> wish;
}
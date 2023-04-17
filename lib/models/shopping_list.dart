class ShoppingList {
  String dateTime;
  String item;
  String totalQuantity;
  String desc;
  bool status;

  ShoppingList({required this.dateTime, required this.item, required this.totalQuantity, required this.desc, required this.status});

  ShoppingList.fromJson(Map<dynamic, dynamic> json)
      : dateTime = json['dateTime'] as String,
        item = json['item'] as String,
        totalQuantity = json['quantity'] as String,
        desc=json['desc'] as String,
        status = json['status'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'dateTime': dateTime,
    'item': item,
    'quantity':totalQuantity,
    'desc':desc,
    'status': status,
  };

  Map<String, dynamic> toMap() => <String, dynamic>{
    'dateTime': dateTime,
    'quantity':totalQuantity,
    'desc':desc,
    'status': status,
  };

  String getItem()=> item;
}
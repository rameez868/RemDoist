class DailyReminder {
   String dateTime;
   String reminder;
   bool status;

  DailyReminder({required this.dateTime, required this.reminder, required this.status});

  DailyReminder.fromJson(Map<dynamic, dynamic> json)
      : dateTime = json['dateTime'] as String,
        reminder = json['reminder'] as String,
        status = json['status'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
     'dateTime': dateTime,
     'reminder': reminder,
     'status': status,
   };

  Map<String, dynamic> toMap() => <String, dynamic>{
        'dateTime': dateTime,
        'reminder': reminder,
        'status': status,
      };

  String getReminder()=> reminder;
}

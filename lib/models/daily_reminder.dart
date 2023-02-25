class DailyReminders {
  final DateTime dateTime;
  final String reminder;

  DailyReminders({required this.dateTime, required this.reminder});

  DailyReminders.fromJson(Map<dynamic, dynamic> json)
      : dateTime = json['dateTime'] as DateTime,
        reminder = json['reminder'] as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{'dateTime': dateTime, 'reminder': reminder};

  Map<String, dynamic> toMap() => <String, dynamic>{
        'dateTime': dateTime,
        'reminder': reminder,
      };
}

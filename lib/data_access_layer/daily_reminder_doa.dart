
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rem_doist/models/daily_reminder.dart';

class DailyReminderDao {
  final _databaseRef = FirebaseDatabase.instance.ref("DailyReminder");

  void saveDailyReminder(DailyReminder dailyReminder) {
    _databaseRef.push().set(dailyReminder.toJson());
  }

  Query getMessageQuery() {
    if(!kIsWeb){
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
    return _databaseRef;
  }

  Future<DailyReminder> getItem(String key) async{
   final snapshot = await _databaseRef.child(key).get();
   var reminder;
   if(snapshot.exists){
     reminder = snapshot.value;
   }


    return reminder;
  }

  void deleteDailyReminder(String key)async {
    await _databaseRef.child(key).remove();

  }
  void updateUser(String key, DailyReminder dailyReminder){
    _databaseRef.child(key).update(dailyReminder.toMap());
  }
}

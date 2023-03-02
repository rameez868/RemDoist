import 'package:flutter/material.dart';
import 'package:rem_doist/data_access_layer/daily_reminder_doa.dart';
import 'package:rem_doist/models/daily_reminder.dart';

class DailyReminderCard extends StatefulWidget {
 DailyReminderCard({Key? key, required this.dailyReminder, required this.snapShotKey}) : super(key: key);
 final DailyReminder dailyReminder;
 final dailReminderDoa = DailyReminderDao();
 final String snapShotKey;


  @override
  State<DailyReminderCard> createState() => _DailyReminderCardState();
}

class _DailyReminderCardState extends State<DailyReminderCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      color: Colors.transparent.withOpacity(0.50),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                  primarySwatch: Colors.lightGreen,
                  unselectedWidgetColor: Colors.deepOrange
              ),
              child: Checkbox(
                value: widget.dailyReminder.status,
                onChanged: (value){
                  setState(() {
                    widget.dailyReminder.status = value!;
                    widget.dailReminderDoa.updateUser(widget.snapShotKey,widget.dailyReminder);
                  });
                },
              ),
            ),
            const SizedBox(width: 15.0,),
            Flexible(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Date: ${widget.dailyReminder.dateTime}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.greenAccent,
                  ),
                ),
                Text(
                  'Reminder: ${widget.dailyReminder.reminder.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.cyan,

                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}




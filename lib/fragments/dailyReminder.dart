import 'package:flutter/material.dart';
import 'package:rem_doist/navigations/navigation_drawer.dart';

class DailyReminderFragment extends StatefulWidget {
  const DailyReminderFragment({Key? key}) : super(key: key);
  static const String routeName = '/HomePage';

  @override
  State<DailyReminderFragment> createState() => _DailyReminderFragmentState();
}

class _DailyReminderFragmentState extends State<DailyReminderFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Comming Soon'),
      ),
      drawer: RemDoistNavigationDrawer(),
    );
  }
}

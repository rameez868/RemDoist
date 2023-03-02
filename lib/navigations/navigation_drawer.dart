import 'package:flutter/material.dart';
import 'package:rem_doist/widgets/navigation.dart';
import 'package:rem_doist/routes/rem_routes.dart';

class RemDoistNavigationDrawer extends StatelessWidget {
  const RemDoistNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createDrawerHeader(),
            createDrawerBodyItem(
                icon: Icons.home,
                text: 'Daily Reminder and Todo List',
                onTap: ()=>Navigator.pushReplacementNamed(context, RemRoutes.dailyReminder)
            ),
          ],
        ),
      ),
    );
  }
}

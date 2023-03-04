import 'package:flutter/material.dart';

Widget createDrawerHeader() {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage('assets/images/female_01.jpg'),
      ),
    ),
    child: Stack(
      children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 30.0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              color: Colors.grey.withOpacity(0.7),
              child: const Text("Reminders and To-Dos",
                  style: TextStyle(
                      fontFamily: "Gothic",
                      color: Colors.greenAccent,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600)),
            )),
      ],
    ),
  );
}

Widget createDrawerBodyItem(
    {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.greenAccent,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(text,
              style: const TextStyle(
                fontFamily: "Gothic",
                color: Colors.white,
              )),
        )
      ],
    ),
    onTap: onTap,
  );
}

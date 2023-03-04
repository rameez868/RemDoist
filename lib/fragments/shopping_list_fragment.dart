import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:rem_doist/navigations/navigation_drawer.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({Key? key}) : super(key: key);
  static const String routeName = '/ShoppingList';
  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const RemDoistNavigationDrawer(),
      appBar: AppBar(
        title: const Text('Shopping List Coming Soon',style: TextStyle(
          fontFamily: "Gothic",
        )),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CircularProgressLoading extends StatefulWidget {
  const CircularProgressLoading({Key? key}) : super(key: key);

  @override
  _CircularProgressLoadingState createState() => _CircularProgressLoadingState();
}

class _CircularProgressLoadingState extends State<CircularProgressLoading> {
  late bool _loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
  }
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 10,
      backgroundColor: Colors.lightBlueAccent,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    );
  }
}

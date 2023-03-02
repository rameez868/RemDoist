import 'package:flutter/material.dart';
import 'package:rem_doist/fragments/daily_reminder_fragment.dart';
import 'dart:math';
import 'dart:async';

import '../widgets/circular_progress_loading.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({Key? key,  required this.title}) : super(key: key );
  final String title;
  @override
  _SplashPageState createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  late int counter=0;
  Random rnd = Random();
  late String saying = "";
  List<String> sayings = [
    "#Markhor🦌",
    "#MeTheLoneWolf🐺",
    "#thuglife☠️👽⚔️🔪⛓",
    "#nothingbox🙇🤷🏽‍♂️🕸🎁",
    "#hakunamatata🐅",
    "#maulahjat🏋🏾‍⚔",
    "#deadman💀⚰️",
    "#deadwillriseagain⚔",
    "#istandalone👑",
    "#istandaloneforjustic🐅☘️",
    "#nøfate⚓️🚀⚰️",
    "#bornfreeandwild👅💪",
    "#bornfreeandlivefree🐅🐆🐈",
    "#brutaltactician🎖",
    "#holysinner🕊",
    "#devilhunter😇",
    "#khalaimakhlooq👻☠️😈🦅👽",
    "#aakhrichittan👻🚶🏽‍♂️🦁🐆🐅🌊🧗🏼‍♂️🥇🎖🏆🗻",
    "#KoiJalGiaKisiNayDuaDi👤🔥🎃☠️🤯😇🙏📦",
    "#ZakhmiDillJallaDon🤦🏻‍♂️🤕🔥💔👿☠️👻",
    "#WhatHappensToTheSoulsWhoLookInTheEyesOfDragon🦖🐉☃️🌊⛈💥🔥🌪🐲☠️👻"
  ];


  void loadingStatus(){
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        counter+=25;
        saying = sayings[rnd.nextInt(18)];
        // Anything else you want
      });
      loadingStatus();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingStatus();
    Timer(const Duration(seconds: 4),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    DailyReminderFragment(),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/phoenix_01.jpg"),
            fit: BoxFit.fill,  ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              const CircularProgressLoading(),
              const SizedBox(height: 20,),
              Text("Loading: $counter%",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color:  Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              Text(saying,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text('App powered by DeadMan Inc.',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color:  Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
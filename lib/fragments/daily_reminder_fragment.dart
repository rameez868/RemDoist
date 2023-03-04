import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rem_doist/data_access_layer/daily_reminder_doa.dart';
import 'package:rem_doist/models/daily_reminder.dart';
import 'package:rem_doist/navigations/navigation_drawer.dart';
import 'package:rem_doist/widgets/circular_progress_loading.dart';
import 'package:rem_doist/widgets/daily_reminder_card.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:draggable_fab/draggable_fab.dart';


class DailyReminderFragment extends StatefulWidget {
  DailyReminderFragment({Key? key}) : super(key: key);
  static const String routeName = '/HomePage';
  final dailReminderDoa = DailyReminderDao();

  @override
  State<DailyReminderFragment> createState() => _DailyReminderFragmentState();
}

class _DailyReminderFragmentState extends State<DailyReminderFragment> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final _reminderController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final Future<FirebaseApp> _futureFirebase = Firebase.initializeApp();
  final ScrollController _scrollController = ScrollController();
  final databaseReference = FirebaseDatabase.instance.ref("DailyReminder");
  String snapshotkey = "";

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/videos/girl_1.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      _controller.setVolume(0);
      _controller.play();
      _controller.setLooping(true);
    });

    final connectedRef = widget.dailReminderDoa.getMessageQuery();
    connectedRef.keepSynced(true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('To-do List',style: TextStyle(
          fontFamily: "Gothic",
        )),
      ),
      drawer: const RemDoistNavigationDrawer(),
      body: FutureBuilder<List<dynamic>>(
        // body: FutureBuilder(
        future: Future.wait([_initializeVideoPlayerFuture, _futureFirebase]),
        //future: _futureFirebase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return Stack(
              //fit: StackFit.expand,
              children: <Widget>[
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: _controller.value.size.width ?? 0,
                      height: _controller.value.size.height ?? 0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                _getReminderList(),
              ],
            );
          } else {
            return const Center(child: CircularProgressLoading());
          }
        },
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          onPressed: () {
            _displayDialog();
          },
          tooltip: 'Add Reminder',
          child: const Icon(Icons.add),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _addData() async {
    String reminder = _reminderController.text;
    //var date = DateTime.parse("2019-04-16 12:18:06.018950");
    var date = DateTime.now();
    var formattedDate = "${date.day}-${date.month}-${date.year}";

    final dailyReminder = DailyReminder(
        dateTime: formattedDate, reminder: reminder, status: false);
    widget.dailReminderDoa.saveDailyReminder(dailyReminder);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Reminder is saved')));
    _reminderController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white70,
            title: Container(
              color: Colors.red,
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text('Add Reminder To List',
                    style: TextStyle(
                      fontFamily: "Gothic",
                    )),
              ),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _reminderController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Reminder',
                      hintStyle: TextStyle(
                        fontFamily: "Gothic",
                      )),
                ),
              ],
            )),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _addData();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add',
                      style: TextStyle(
                        fontFamily: "Gothic",
                      ))),
              TextButton(
                  onPressed: () {
                    _reminderController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                        fontFamily: "Gothic",
                      )))
            ],
          );
        });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Widget _getReminderList() {
    return Expanded(
        child: FirebaseAnimatedList(
      controller: _scrollController,
      query: widget.dailReminderDoa.getMessageQuery(),
      itemBuilder: (context, snapshot, animation, index) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        final dailyReminder = DailyReminder.fromJson(json);
        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              try {
                widget.dailReminderDoa
                    .deleteDailyReminder(snapshot.key.toString());
              } catch (e) {
                rethrow;
              }
              // Then show a snackbar.
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Reminder dismissed',
                      style: TextStyle(
                        fontFamily: "Gothic",
                      ))));
            },
            // Show a red background as the item is swiped away.
            background: Container(color: Colors.red),
            child: DailyReminderCard(
              dailyReminder: dailyReminder,
              snapShotKey: snapshot.key.toString(),
            ));
      },
    ));
  }
}

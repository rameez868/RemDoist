import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rem_doist/data_access_layer/wish_list_dao.dart';
import 'package:rem_doist/models/wish_list.dart';
import 'package:rem_doist/navigations/navigation_drawer.dart';
import 'package:rem_doist/widgets/circular_progress_loading.dart';
import 'package:rem_doist/widgets/wish_list_card.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:draggable_fab/draggable_fab.dart';

class WishListFragment extends StatefulWidget {
  WishListFragment({Key? key}) : super(key: key);
  static const String routeName = '/WishListPage';
  final wishListDoa = WishListDao();

  @override
  State<WishListFragment> createState() => _WishListFragmentState();
}

class _WishListFragmentState extends State<WishListFragment> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final Future<FirebaseApp> _futureFirebase = Firebase.initializeApp();
  final ScrollController _scrollController = ScrollController();
  final databaseReference = FirebaseDatabase.instance.ref("WishList");
  final _wishController = TextEditingController();
  String snapshotkey = "";

  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.asset('assets/videos/couple_1.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      _controller.setVolume(0);
      _controller.play();
      _controller.setLooping(true);
    });
    final connectedRef = widget.wishListDoa.getMessageQuery();
    connectedRef.keepSynced(true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _clearController(){
    _wishController.clear();
  }

  void _addList(){
    var date = DateTime.now();
    var fDate = "${date.day}-${date.month}-${date.year}";
    String wish = _wishController.value.text;

    WishList wishList = WishList(dateTime: fDate, wish: wish, status: false);

    widget.wishListDoa.saveWish(wishList);
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
                child: Text('Add Wish To List',
                    style: TextStyle(
                      fontFamily: "Gothic",
                    )),
              ),
            ),
            content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _wishController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          labelText: "Wish List Item",
                          labelStyle: TextStyle(
                            fontFamily: "Gothic",
                          ),
                          hintText: 'Enter List Item',
                          hintStyle: TextStyle(
                            fontFamily: "Gothic",
                          )),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                )),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                     _addList();
                     _clearController();
                  },
                  child: const Text('Add',
                      style: TextStyle(
                        fontFamily: "Gothic",
                      ))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                     _clearController();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                        fontFamily: "Gothic",
                      )))
            ],
          );
        });
  }

  _getWishList(){
    return Expanded(
        child: FirebaseAnimatedList(
          query: widget.wishListDoa.getMessageQuery(),
          itemBuilder: (context,snapshot,animation,index){
            final json = snapshot.value as Map<dynamic,dynamic>;
            final wishList = WishList.fromJson(json);
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (direction){
                try{
                  widget.wishListDoa.deleteWish(snapshot.key.toString());
                } catch(e){
                  rethrow;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                          "List Item Dismissed",
                          style: TextStyle(
                              fontFamily: "Gothic"
                          ),
                        ))
                );
              },
              child: WishListCard(
                wishList: wishList,
                snapShopKey: snapshot.key.toString(),
              ),
            );
          },
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Wish List',style: TextStyle(
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
                _getWishList(),
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
          tooltip: 'Add Wish',
          child: const Icon(Icons.add),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

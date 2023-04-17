import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:rem_doist/navigations/navigation_drawer.dart';
import 'package:rem_doist/widgets/circular_progress_loading.dart';
import 'package:rem_doist/models/shopping_list.dart';
import 'package:rem_doist/data_access_layer/shopping_list_doa.dart';
import 'package:rem_doist/widgets/shopping_list_card.dart';


class ShoppingListFragment extends StatefulWidget {
  ShoppingListFragment({Key? key}) : super(key: key);
  static const String routeName = '/ShoppingList';
  @override
  State<ShoppingListFragment> createState() => _ShoppingListFragmentState();
  final shoppingListDao = ShoppingListDao();
}

class _ShoppingListFragmentState extends State<ShoppingListFragment> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final Future<FirebaseApp> _futureFirebase = Firebase.initializeApp();
  final databaseReference = FirebaseDatabase.instance.ref('ShoppingList');
  final ScrollController _scrollController = ScrollController();
  final _itemController = TextEditingController();
  final _itemQuantityController = TextEditingController();
  final _itemUnitController = TextEditingController();
  final _itemPackController = TextEditingController(text: "1");
  final _itemDescController = TextEditingController();

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/videos/girl_1.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      _controller.setVolume(0);
      _controller.play();
      _controller.setLooping(true);
    });

    final connectedRef = widget.shoppingListDao.getShoppingListQuery();
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
      drawer: const RemDoistNavigationDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Shopping List',
            style: TextStyle(
              fontFamily: "Gothic",
            )),
      ),
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
              _getShoppingList(),
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
                child: Text('Add Item To List',
                    style: TextStyle(
                      fontFamily: "Gothic",
                    )),
              ),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(
                      labelText: "Item Name",
                      labelStyle: TextStyle(
                        fontFamily: "Gothic",
                      ),
                      hintText: 'Enter Item Name',
                      hintStyle: TextStyle(
                        fontFamily: "Gothic",
                      )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextField(
                        decoration: const InputDecoration(
                            labelText: "Item Quantity",
                            labelStyle: TextStyle(
                              fontFamily: "Gothic",
                            ),
                            hintText: 'Enter Quantity',
                            hintStyle: TextStyle(
                              fontFamily: "Gothic",
                            )),
                        controller: _itemQuantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        decoration: const InputDecoration(
                            labelText: "Item Unit",
                            labelStyle: TextStyle(
                              fontFamily: "Gothic",
                            ),
                            hintText: 'Enter Unit',
                            hintStyle: TextStyle(
                              fontFamily: "Gothic",
                            )),
                        controller: _itemUnitController,
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.singleLineFormatter
                        ], // Only numbers can be entered
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _itemPackController,
                  decoration: const InputDecoration(
                      labelText: "Item Pack",
                      labelStyle: TextStyle(
                        fontFamily: "Gothic",
                      ),
                      hintText: 'Enter Pack',
                      hintStyle: TextStyle(
                        fontFamily: "Gothic",
                      )),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _itemDescController,
                  decoration: const InputDecoration(
                    labelText: "Item Description",
                    labelStyle: TextStyle(
                        fontFamily: "Gothic",
                      ),
                    hintText: 'Enter Description',
                    hintStyle: TextStyle(
                        fontFamily: "Gothic",
                      )
                  ),
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
  void _addList(){
    String itemName = _itemController.value.text;
    String itemQuantity = _itemQuantityController.value.text;
    String itemPack = _itemPackController.value.text;
    String itemUnit = _itemUnitController.value.text;
    String itemDesc = _itemDescController.value.text;
    var date = DateTime.now();
    var fDate = "${date.day}-${date.month}-${date.year}";

    String totalQuantity = '$itemPack * $itemQuantity $itemUnit';

    var item = ShoppingList(dateTime: fDate, item: itemName, totalQuantity: totalQuantity, desc: itemDesc, status: false);

    widget.shoppingListDao.saveShoppingList(item);

  }
  void _clearController(){
    _itemPackController.clear();
    _itemController.clear();
    _itemDescController.clear();
    _itemQuantityController.clear();
    _itemUnitController.clear();
  }
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
  _getShoppingList() {
    return Expanded(
        child: FirebaseAnimatedList(
          query: widget.shoppingListDao.getShoppingListQuery(),
          itemBuilder: (context,snapshot,animation,index){
            final json = snapshot.value as Map<dynamic,dynamic>;
            final shoppingList = ShoppingList.fromJson(json);
            return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction){
                  try{
                    widget.shoppingListDao.deleteShoppingItem(snapshot.key.toString());
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
                child: ShoppingListCard(
                  shoppingList: shoppingList,
                  snapShopKey: snapshot.key.toString(),
                ),
            );
          },
        )
    );
  }
}
//https://morioh.com/p/d98e6eebbfec

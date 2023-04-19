import 'package:flutter/material.dart';
import 'package:rem_doist/data_access_layer/wish_list_dao.dart';
import 'package:rem_doist/models/wish_list.dart';
import 'package:rem_doist/extensions/string_extension.dart';

class WishListCard extends StatefulWidget {
  WishListCard({Key? key, required this.wishList, required this.snapShopKey}) : super(key: key);
  final WishList wishList;
  final wishListDao = WishListDao() ;
  final String snapShopKey;

  @override
  State<WishListCard> createState() => _WishListCardState();
}

class _WishListCardState extends State<WishListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      color: Colors.transparent.withOpacity(0.50),
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
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
                value: widget.wishList.status,
                onChanged: (value){
                  setState(() {
                    widget.wishList.status = value!;
                    widget.wishListDao.updateWish(
                        widget.snapShopKey,
                        widget.wishList
                    );
                  });
                },
              ),
            ),
            const SizedBox(width:15.0),
            Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Date: ${widget.wishList.dateTime}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Gothic",
                        color: Colors.greenAccent,
                      ),
                    ),
                    Text(
                      'Item: ${widget.wishList.wish.toTitleCase()}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Gothic",
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rem_doist/data_access_layer/shopping_list_doa.dart';
import 'package:rem_doist/models/shopping_list.dart';
import 'package:rem_doist/extensions/string_extension.dart';

class ShoppingListCard extends StatefulWidget {
   ShoppingListCard({Key? key, required this.shoppingList, required this.snapShopKey}) : super(key: key);
  final ShoppingList shoppingList;
  final shoppingListDao = ShoppingListDao() ;
  final String snapShopKey;

  @override
  State<ShoppingListCard> createState() => _ShoppingListCardState();
}

class _ShoppingListCardState extends State<ShoppingListCard> {
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
                value: widget.shoppingList.status,
                onChanged: (value){
                  setState(() {
                    widget.shoppingList.status = value!;
                    widget.shoppingListDao.updateShoppingItem(
                        widget.snapShopKey,
                        widget.shoppingList
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
                      'Date: ${widget.shoppingList.dateTime}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Gothic",
                        color: Colors.greenAccent,
                      ),
                    ),
                    Text(
                      'Item: ${widget.shoppingList.item.toTitleCase()}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Gothic",
                        color: Colors.cyan,
                      ),
                    ),
                    Text(
                      'Total Quantity: ${widget.shoppingList.totalQuantity}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Gothic",
                        color: Colors.cyan,
                      ),
                    ),
                    Text(
                      'Description: ${widget.shoppingList.desc.toTitleCase()}',
                      style: const TextStyle(
                        fontSize: 18.0,
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

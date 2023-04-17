import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rem_doist/models/shopping_list.dart';


class ShoppingListDao{
  final _databaseRef = FirebaseDatabase.instance.ref("ShoppingList");

  void saveShoppingList(ShoppingList shoppingList){
    _databaseRef.push().set(shoppingList.toJson());
  }

  Query getShoppingListQuery(){
    if(!kIsWeb){
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
    return _databaseRef;
  }

  Future<ShoppingList> getShoppingItem(String key) async{
    final snapShot = await _databaseRef.child(key).get();
    var ShoppingItem;
    if(snapShot.exists){
      ShoppingItem = snapShot.value;
    }
    return ShoppingItem;
  }

  void deleteShoppingItem(String key) async => await _databaseRef.child(key).remove();

  void updateShoppingItem(String key, ShoppingList shoppingList) => _databaseRef.child(key).update(shoppingList.toMap());

}
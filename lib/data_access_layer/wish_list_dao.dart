import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rem_doist/models/wish_list.dart';

class WishListDao {
  final _databaseRef = FirebaseDatabase.instance.ref("WishList");

  void saveWish(WishList wishList) {
    _databaseRef.push().set(wishList.toJson());
  }

  Query getMessageQuery() {
    if(!kIsWeb){
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
    return _databaseRef;
  }

  Future<WishList> getItem(String key) async{
    final snapshot = await _databaseRef.child(key).get();
    var wishList;
    if(snapshot.exists){
      wishList = snapshot.value;
    }


    return wishList;
  }

  void deleteWish(String key)async {
    await _databaseRef.child(key).remove();

  }
  void updateWish(String key, WishList wishList){
    _databaseRef.child(key).update(wishList.toMap());
  }
}

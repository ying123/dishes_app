import '../common/Storage.dart';
import 'dart:convert';

class UserStorage{

  static setUser(value) async{
    try {
      await Storage.setString('userInfo', json.encode(value));
    } catch (e) {
      await Storage.setString('userInfo', json.encode(value));
    }
  }

  static getUser() async{
    try {
      var searchListData = json.decode(await Storage.getString('userInfo'));
      return searchListData;
    } catch (e) {
      return null;
    }
  }
  static remove() async{
    await Storage.remove("userInfo");
  }

}
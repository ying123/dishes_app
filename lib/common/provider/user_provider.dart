import '../../model/users.dart';
import 'package:flutter/material.dart';
class UserProvider with ChangeNotifier{

  Map<String,dynamic> _userModel;

  Map<String,dynamic> get getUser=>_userModel;

  void setUser(Map<String,dynamic> userModel){
    this._userModel=userModel;
    notifyListeners();
  }

}
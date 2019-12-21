import 'package:flutter/material.dart';
class CurrentIndexProvider with ChangeNotifier{

  int _currentIndex=0;
  int get getIndex=> _currentIndex;
  void setCurrentIndex(int currentIndex){
    this._currentIndex=currentIndex;
    notifyListeners();
  }
}
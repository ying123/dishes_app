import '../../model/order.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier{
  OrderModel _model=OrderModel();
  void setOrder(OrderModel model){
    this._model=model;
    notifyListeners();
  }
  OrderModel get getOrder => _model;
}
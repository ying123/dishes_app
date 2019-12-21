import '../../model/cart_info.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {

  List<OrderInfo> _orders=List<OrderInfo>();
  int _totalCount=0;
  double _totalPrice=0.0;
  int get totalCount => _totalCount;
  double get totalPrice => _totalPrice;
  List<OrderInfo> get getOrders => _orders;
  void setOrders(List<OrderInfo> orders){
    this._orders=orders;
    _totalCount=0;
    _totalPrice=0.0;
    for(int i=0;i<_orders.length;i++){
      _totalCount+=_orders[i].count;
      _totalPrice+=_orders[i].count * double.parse( _orders[i].price);
    }
    notifyListeners();
  }
  void editOrder(OrderInfo order){
    switch(order.code){
      case "ORDER_NEW":
        _orders.add(order);
        break;
      case "ORDER_ADD":
        for(int i=0;i<_orders.length;i++){
          if(_orders[i].foodId==order.foodId){
            _orders.removeAt(i);
            _orders.insert(i, order);
          }
        }
        break;
      case "ORDER_SUB":
        for(int i=0;i<_orders.length;i++){
          if(_orders[i].foodId==order.foodId){
            _orders.removeAt(i);
            _orders.insert(i, order);
          }
        }
        break;
      case "ORDER_DEL":
        for(int i=0;i<_orders.length;i++){
          if(_orders[i].foodId==order.foodId){
            _orders.removeAt(i);
          }
        }
        break;
    }
    _totalCount=0;
    _totalPrice=0.0;
    for(int i=0;i<_orders.length;i++){
      _totalCount+=_orders[i].count;
      _totalPrice+=_orders[i].count *double.parse( _orders[i].price);
    }
    notifyListeners();
  }
  // int _count = 0;
  // int get count => _count;
  // void setCount(int count) {
  //   count = _count;
  //   notifyListeners();
  // }

  // void addCount() {
  //   _count++;
  //   notifyListeners();
  // }
  // void subCount() {
  //   _count--;
  //   notifyListeners();
  // }
}

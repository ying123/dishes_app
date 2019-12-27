
import 'package:flutter/cupertino.dart';

class HistOrder extends StatefulWidget{
  String phone;
  HistOrder(this.phone);
  @override
  State<StatefulWidget> createState() =>_HistOrder();

}
class _HistOrder extends State<HistOrder>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("历史"),
    );
  }

}
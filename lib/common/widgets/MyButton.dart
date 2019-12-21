import 'package:flutter/material.dart';
import '../../common/ScreenAdapter.dart';
class MyButton extends StatelessWidget{
  String title;
  double width;
  double size;
  Color color;
  Object onTap;
  MyButton({this.title="按钮",this.width=200.0,this.color=Colors.red,this.onTap=null,this.size=34});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: ScreenAdapter.width(width),
        margin: EdgeInsets.all(ScreenAdapter.width(10)),
        padding: EdgeInsets.all(ScreenAdapter.width(10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: color),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: ScreenAdapter.size(size)),
          ),
        ),
      ),
    );
  }
}
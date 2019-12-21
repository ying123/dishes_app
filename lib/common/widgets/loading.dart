import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../ScreenAdapter.dart';
class LoadingWidget extends StatefulWidget{
  _loadingWidget createState()=>_loadingWidget();
}
class _loadingWidget extends State<StatefulWidget>{
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
          child: Center(
            child: SpinKitFadingCircle(
                color: Colors.green[300],
                size: ScreenAdapter.size(30),
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: Center(
            child: Text("加载中...",style: TextStyle(fontSize: ScreenAdapter.size(12),color: Colors.black),),
          ),
        )
      ],
    );
//    return Container(
//      width: ScreenAdapter.getScreenWidth(),
//      height: ScreenAdapter.getScreenHeight(),
//      child: SpinKitFadingCircle(
//        color: Colors.green,
//        size: ScreenAdapter.size(30),
//      ),
//    );
  }

}
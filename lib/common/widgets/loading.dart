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
    return Center(
        child: SpinKitFadingCircle(
          color: Colors.green[300],
          size: ScreenAdapter.size(50),
        ),
    );
  }

}
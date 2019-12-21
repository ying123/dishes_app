import 'package:flutter_screenutil/flutter_screenutil.dart';
class ScreenAdapter{
  static init(context){
    ScreenUtil.instance=ScreenUtil(width: 750,height: 1334)..init(context);
  }
  static height(double value){
    return ScreenUtil.instance.setHeight(value);
  }
  static width(double value){
    return ScreenUtil.instance.setWidth(value);
  }
  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }

  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  static size(double value){
    return ScreenUtil.getInstance().setSp(value);
  }
  //状态栏高度
  static statusBarHeight(){
    return ScreenUtil.statusBarHeight;
  }
  //底部安全区域高度
  static bottomBarHeight(){
    return ScreenUtil.bottomBarHeight;
  }
}
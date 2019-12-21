import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';
class Routers {
  //根路由
  static String root = "/root";
  //点餐主页
  static String food ="/food";
  //菜品详情
  static String foodDetail ="/foodDetail";
  //修改用餐人数
  static String editpNum ="/editpNum";
  //登录
  static String userLogin ="/userLogin";
   //注册
  static String userRegister ="/userRegister";
   //忘记密码
  static String forgetPwd ="/userForgetPwd";


  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("route was not found !!!");
    });
    router.define(root, handler: rootHandler);
    router.define(food, handler: foodHandler);
    router.define(foodDetail, handler: foodDetailHandler);
    router.define(editpNum, handler: editpNumHandler);
    router.define(userLogin, handler: userLoginHandler);
    router.define(userRegister, handler: userRegisterHandler);
    router.define(forgetPwd, handler: userForgetPwdHandler);
  }
}
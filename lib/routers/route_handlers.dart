import 'package:dishes_app/tabs/homePage.dart';

import '../pages/user/forget_pwd.dart';

import '../pages/user/register.dart';

import '../pages/user/login.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../pages/edit_p_num.dart';
import '../tabs/Tabs.dart';
import '../pages/food.dart';
import '../pages/foodDetail.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String json = params["params"]?.first  ;
  return Tabs(params: json,);
});
var foodHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Food();
});

//菜品详情
var foodDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  int foodId = int.parse(params["foodId"]?.first);
  return FoodDetail(
    foodId: foodId,
  );
});
//修改用餐人数
var editpNumHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String json = params["params"]?.first  ;
  return Edit_PNum(params:json);
});
//用户登录
var userLoginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});
//用户注册
var userRegisterHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Register();
});
//忘记密码
var userForgetPwdHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ForgetPwd();
});
//扫码点餐
var homeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return HomePage();
    });

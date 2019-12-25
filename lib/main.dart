import './common/http_util.dart';
import './pages/user/login.dart';
import './services/user_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/config/constant.dart';
import 'common/provider/cart_provider.dart';
import 'common/provider/user_provider.dart';
import 'common/provider/order_provider.dart';
import 'model/users.dart';
import 'routers/Application.dart';
import 'routers/Routers.dart';
import 'tabs/homePage.dart';
import 'common/config/api_config.dart' as Config;

void main() async{
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  var user = await UserStorage.getUser();
  Widget page=HomePage();
  if(user==null){
    page=LoginPage();
  }else{
    //登录
    await _login(user);
  }
  runApp(MyApp(page));
}
_login(user) async{
  await HttpUtil.getInstance().post("${Config.Api.host+Config.Api.login}", data: {Constant.phone: user["phone"], Constant.pwd: user["pwd"]}).then((res){
    UserModel user= UserModel.fromJson(res[Constant.result]);
    UserStorage.setUser({Constant.phone: user.phone, Constant.pwd: user.pwd,"token":user.token});//用户名密码存本地
    Application.token=user.token;
  });
}

class MyApp extends StatelessWidget {
  Widget page;
  MyApp(this.page);
  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routers.configureRoutes(router); //路由回调
    Application.router = router;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: Consumer<CartProvider>(
          builder: (context, counter, _) {
            return MaterialApp(
              title: '自主点餐',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home:page,
            );
          },
        ),
      );

  }
}

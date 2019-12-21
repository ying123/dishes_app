import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'common/provider/cart_provider.dart';
import 'common/provider/current_index_provider.dart';
import 'common/provider/order_provider.dart';
import 'common/utils/toast.dart';
import 'routers/Application.dart';
import 'routers/Routers.dart';
import 'tabs/homePage.dart';
import 'package:flutter/services.dart';

void main() {
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routers.configureRoutes(router); //路由回调
    Application.router = router;
    return WillPopScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => CurrentIndexProvider()),
        ],
        child: Consumer<CartProvider>(
          builder: (context, counter, _) {
            return MaterialApp(
              title: '点餐系统',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home: HomePage(),
            );
          },
        ),

      ),
      onWillPop: ()async{
        // 点击返回键的操作
        if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)){
          lastPopTime = DateTime.now();
          Toast.toast(context,msg: '再按一次退出');

        }else{
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');


        }

      },

    );
  }
}

import 'dart:convert';
import '../common/utils/toast.dart';
import 'package:flutter/services.dart';
import '../model/cart_info.dart';
import '../common/provider/order_provider.dart';
import '../model/order.dart';
import '../common/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../pages/food.dart';
import 'CartPage.dart';
import 'MyPage.dart';
import '../common/ScreenAdapter.dart';
import '../common/config/api_config.dart';
import '../common/http_util.dart';

class Tabs extends StatefulWidget {
  var params;
  Tabs({this.params});
  State<StatefulWidget> createState() => _Tabs();
}

class _Tabs extends State<Tabs> {
  IOWebSocketChannel _channel;
  PageController _pageController;
  List<Widget> _listPages;
  var _params;
  DateTime lastPopTime;


  _init() {
    var list = List<int>();
    ///字符串解码
    jsonDecode(widget.params).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    _params = json.decode(value);
    _listPages = [Food(params: _params,), CartPage(params: _params,), MyPage(_params)];
    _getCartList();
    //初始化连接服务器
    _channel = IOWebSocketChannel.connect('${Api.wsHost+_params["tableNo"]}');//webSocket服务地址
    _channel.stream.listen((message) {
      //接收服务器推送的消息，保存Provider
      Provider.of<CartProvider>(context).editOrder(OrderInfo.fromJson(json.decode(message)));
    });
  }
  //获取购物车列表
  _getCartList() async{
    await HttpUtil.getInstance().get("${Api.cart_info_listByTableNo}/${_params["tableNo"]}").then((res){
      OrderInfoModel orderInfo=OrderInfoModel.fromJson(res);
      if(orderInfo.result.length>0){
        Provider.of<CartProvider>(context).setOrders(orderInfo.result);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
    _pageController = PageController(initialPage: _params["currentIndex"]);
  }


  @override
  void dispose() {
    //销毁socket
    _channel.sink.close();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ScreenAdapter.init(context);
    return WillPopScope(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _listPages,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _params["currentIndex"],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          onTap: (index) {
            setState(() {
              _params["currentIndex"] = index;
              _pageController.jumpToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("点菜")),
            BottomNavigationBarItem(
              icon: Stack(
                children: <Widget>[
                  Container(
                    child: Icon(Icons.shopping_cart),
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                  ),

                  Provider.of<CartProvider>(context).totalCount==0? Text(""): Positioned(
                    right: 0,
                    bottom: 10,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      width: ScreenAdapter.width(22),
                      height: ScreenAdapter.width(22),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                      ),
                      child: Text(
                        "${Provider.of<CartProvider>(context).totalCount}",
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(14),
                            color: Colors.white),
                      ),

                    ),
                  ),

                ],
              ),
              //icon: Icon(Icons.add_shopping_cart),
              title: Text("餐车"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: Text("用户中心")),
          ],
        ),
      ),
      onWillPop: ()async{
        if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)){
          lastPopTime = DateTime.now();
          Toast.toast(context,msg: '再按一次退出');
          return false;
        }else{
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }
}

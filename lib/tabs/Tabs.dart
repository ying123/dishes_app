import 'dart:convert';
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
import '../common/config/Config.dart'as Config;
import '../common/Http.dart' as http;

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


  _init() {
    var list = List<int>();
    ///字符串解码
    jsonDecode(widget.params).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    _params = json.decode(value);
    _listPages = [Food(params: _params,), CartPage(params: _params,), MyPage()];
    _getCartList();
    String webSocket="";

    if(_params["remark"]==""){
      _params["remark"]="not";
    }
    webSocket='${Config.Api.wsHost}${_params["tableNo"]}/${_params["phone"]}/${_params["personNum"]}/${_params["remark"]}';
    //初始化连接服务器
    _channel = IOWebSocketChannel.connect(webSocket);
    //_channel.sink.add(json.encode({"tableNo":"a002","phone":"13882870519",'personnum':"2人","remark":"不要放辣椒"}) );
    _channel.stream.listen((message) {
      var data= json.decode(message);
      if(data["code"]==null){
        Provider.of<OrderProvider>(context).setOrder(OrderModel.fromJson(data));
      }else{
        Provider.of<CartProvider>(context).editOrder(OrderInfo.fromJson(data));
      }
    });
  }
  //获取购物车列表
  _getCartList() async{
    await http.get("${Config.Api.cart_info_listByTableNo}/${_params["tableNo"]}").then((res){
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
    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
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
            title: Text("购物车"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("我的")),
        ],
      ),
    );
  }
}
import 'dart:convert';
import 'package:dishes_app/common/provider/order_provider.dart';
import 'package:dishes_app/common/provider/user_provider.dart';
import 'package:dishes_app/model/category.dart';
import 'package:dishes_app/model/food.dart' as prefix0;
import 'package:dishes_app/model/order.dart';
import 'package:dishes_app/routers/Routers.dart';
import 'package:fluro/fluro.dart';
import '../model/cart_info.dart';
import 'package:flutter/material.dart';
import '../common/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import '../common/ScreenAdapter.dart';
import '../common/widgets/MyButton.dart';
import '../routers/Application.dart';
import '../common/config/api_config.dart';
import '../common/http_util.dart';

class CartPage extends StatefulWidget {
  var params;
  CartPage({this.params});
  @override
  _CartPage createState() => _CartPage();
}

class _CartPage extends State<CartPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  _divider() {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
      child: Divider(
        height: ScreenAdapter.height(1),
        color: Colors.grey[300],
      ),
    );
  }

  List<OrderInfo> _orderList = [];
  List<FoodModel> _foodLike=[];
  //底部弹出框
  _showBottomSheet() {
    showBottomSheet(context: context, builder: (context) {
      return  Container(
          margin: EdgeInsets.all(ScreenAdapter.height(50)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () async{
                    await HttpUtil.getInstance().post(Api.accounts,data: {"tableNo":widget.params["tableNo"],"price":"${Provider.of<CartProvider>(context).totalPrice}"}).then((res){
                      if(res["result"]){
                        Provider.of<CartProvider>(context).setOrders(List<OrderInfo>());
                        Provider.of<OrderProvider>(context).setOrder(OrderModel());
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Container(
                    width: ScreenAdapter.height(100),
                    height: ScreenAdapter.height(100),
                    margin: EdgeInsets.only(left: ScreenAdapter.width(50)),
                    child: Image.asset("./static/wx.png"),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: ScreenAdapter.height(100),
                    height: ScreenAdapter.height(100),
                    margin: EdgeInsets.only(right: ScreenAdapter.width(50)),
                    child: Image.asset("./static/zfb.png"),
                  ),
                )
              ]),
        );
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HttpUtil.getInstance().get(Api.sellLike).then((res){
      List<FoodModel> data=[];
      res["result"].forEach((v) {
        data.add(FoodModel.fromJson(v));
      });
      setState(() {
        this._foodLike=data;
      });
    });
  }
  @override
  

  //提示组件
  _title() {
    List<Widget> _list = [];
    _list.add(Container(
      height: ScreenAdapter.height(200),
      width: double.infinity,
      child: Center(
        child: Text(
          "餐车空空如也,快去点餐吧",
          style: TextStyle(fontSize: ScreenAdapter.size(30)),
        ),
      ),
    ));
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    _orderList=Provider.of<CartProvider>(context).getOrders;
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("我的餐车"),
        leading: null,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Color.fromRGBO(247, 247, 247, 0.9),
                    child: Column(
                      children: <Widget>[
                        //显示用餐人数,计算总价
                        _pNumWidget(),
                        //购物车列表
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenAdapter.width(20),
                                right: ScreenAdapter.width(20),
                                bottom: ScreenAdapter.width(20)),
                            padding: EdgeInsets.only(
                                left: ScreenAdapter.width(20),
                                right: ScreenAdapter.width(20)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenAdapter.size(8)),
                                color: Colors.white),
                            child: Column(
                                children: _orderList.length == 0
                                    ? _title()
                                    : _cartListWidget(_orderList))),
                        Container(
                          child: Center(
                            child: Text(
                              "本店顾客最常点的菜",
                              style:
                                  TextStyle(fontSize: ScreenAdapter.size(30)),
                            ),
                          ),
                        ),
                        //
                        _likeWeight()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          //底部按钮组件
          _bottomButton()
        ],
      ),
    );
  }

  //底部按钮
  _bottomButton() {
    return Container(
      width: double.infinity,
      height: ScreenAdapter.height(100),
      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300])),
      ),
      child: MyButton(
        title: Provider.of<CartProvider>(context).totalPrice==0?"下单":"下单(${Provider.of<CartProvider>(context).totalPrice})",
        onTap: () {
          if(Provider.of<CartProvider>(context).totalPrice==0){

            return;
          }
          _showBottomSheet();
        },
      ),
    );
  }

  ///本店顾客最常点的菜
  Widget _likeWeight() {
    return Container(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      margin: EdgeInsets.all(ScreenAdapter.width(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(ScreenAdapter.size(8)),
        ),
      ),
      height: ScreenAdapter.height(300),
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Application.router.navigateTo(context, "/foodDetail?foodId=${_foodLike[index].foodId}");
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("${Api.imgUrl+_foodLike[index].imgUrl}"),
                    ),
                  ),
                  width: ScreenAdapter.height(180),
                  height: ScreenAdapter.height(180),
                  margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                ),
              ),

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: ScreenAdapter.width(160),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${_foodLike[index].foodName}",
                          style: TextStyle(fontSize: ScreenAdapter.size(24)),
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenAdapter.width(160),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "￥${_foodLike[index].price}",
                          style: TextStyle(fontSize: ScreenAdapter.size(24)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // child: Text("￥12",
              //     style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          );
        },
        itemCount: _foodLike.length,
      ),
    );
  }

  //用餐人数
  _pNumWidget() {
    return Container(
      margin: EdgeInsets.all(ScreenAdapter.width(20)),
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenAdapter.size(8)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "用餐人数：${Provider.of<OrderProvider>(context).getOrder.personNum??""}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenAdapter.size(26)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenAdapter.width(20)),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "备注：${Provider.of<OrderProvider>(context).getOrder.remark??""}",
                            style: TextStyle(fontSize: ScreenAdapter.size(26)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: ScreenAdapter.width(100),
                child: GestureDetector(
                  onTap: () {
//                    String jsonString = json.encode(widget.params);
//                    var jsons = jsonEncode(Utf8Encoder().convert(jsonString));
                    Application.router.navigateTo(context, Routers.editpNum);
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "./static/edit.png",
                        width: ScreenAdapter.width(60),
                        height: ScreenAdapter.height(60),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenAdapter.width(10)),
                        child: Align(
                          child: Text("修改"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          _divider(),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Text("购物车中共有"),
                      Text(
                        " ${Provider.of<CartProvider>(context).totalCount} ",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdapter.size(36)),
                      ),
                      Text("个菜"),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Text("合计："),
                      Text(
                        "￥${Provider.of<CartProvider>(context).totalPrice}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdapter.size(40)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _divider(),
        ],
      ),
    );
  }

  //购物车列表
  _cartListWidget(List<OrderInfo> list) {
    List<Widget> _list = [];
    for (int i = 0; i < list.length; i++) {
      _list.add(Container(
        margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: ScreenAdapter.height(160),
                    height: ScreenAdapter.height(160),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://www.zlp.ltd/images/${list[i].imgUrl}",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenAdapter.width(200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(ScreenAdapter.width(20)),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(list[i].foodName),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(ScreenAdapter.width(20)),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("￥${list[i].price}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async{
                                var data={"foodId":list[i].foodId,"tableNo":list[i].tableNo,"count":1,"operation":0 };
                                await HttpUtil.getInstance().post("${Api.cart_item_edit}",data: data);
                                //http.post("${Config.Api.cart_item_edit}",formData:data );
                              },
                              child: Container(
                                width: ScreenAdapter.width(80),
                                height: ScreenAdapter.width(80),
                                padding: EdgeInsets.all(ScreenAdapter.size(10)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[100]),
                                ),
                                child: Image.asset("./static/sub.png"),
                              ),
                            ),
                            Container(
                              width: ScreenAdapter.width(80),
                              height: ScreenAdapter.width(80),
                              decoration: BoxDecoration(
                                  border: Border(
                                top: BorderSide(color: Colors.grey[100]),
                                bottom: BorderSide(color: Colors.grey[100]),
                              )),
                              child: Center(
                                child: Text(
                                  "${list[i].count}",
                                  style: TextStyle(
                                      fontSize: ScreenAdapter.size(38)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: ()async {
                                var data={"foodId":list[i].foodId,"tableNo":list[i].tableNo,"count":1,"operation":1 };
                                await HttpUtil.getInstance().post("${Api.cart_item_edit}",data: data);
                              },
                              child: Container(
                                width: ScreenAdapter.width(80),
                                height: ScreenAdapter.width(80),
                                padding: EdgeInsets.all(ScreenAdapter.size(10)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[100]),
                                ),
                                child: Image.asset("./static/add.png"),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
            i == list.length - 1 ? Text("") : _divider()
          ],
        ),
      ));
    }
    return _list;
  }
}

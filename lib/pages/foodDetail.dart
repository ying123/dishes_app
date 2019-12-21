
import 'dart:convert';

import 'package:fluro/fluro.dart';

import '../routers/Application.dart';
import 'package:flutter/material.dart';
import '../common/ScreenAdapter.dart';
import '../common/config/Config.dart' as Config;
import '../common/Http.dart' as http;
import '../common/widgets/MyButton.dart';
import '../model/food.dart';

class FoodDetail extends StatefulWidget {
  int foodId;
  FoodDetail( {@required this.foodId});
  State<StatefulWidget> createState() => _FoodDetail();
}

class _FoodDetail extends State<FoodDetail> {
  int _count = 1;
  Food _result;
  @override
  void initState() {
    super.initState();
    http
        .get(Config.Api.foodById +"${widget.foodId}")
        .then((res) {
      FoodModel model = FoodModel.fromJson(res);
      setState(() {
        _result = model.result;
        _result.imgUrl="https://www.zlp.ltd/images/${_result.imgUrl}";
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(_result.categroyId);
            },
            child: Container(
              margin: EdgeInsets.all(ScreenAdapter.width(20)),
              width: ScreenAdapter.width(20),
              height: ScreenAdapter.height(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          title: Text("菜品详情"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                width: ScreenAdapter.getScreenWidth(),
                color: Color.fromRGBO(247, 247, 247, 0.0),
                child: _result == null
                    ? Center(
                        child: Text("加载中...."),
                      )
                    : ListView(
                        children: <Widget>[
                          Container(
                            height: ScreenAdapter.height(540),
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: ScreenAdapter.height(400),
                                  width: ScreenAdapter.getScreenWidth(),
                                  child: Image.network(
                                    _result.imgUrl,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenAdapter.height(20),
                                        left: ScreenAdapter.width(20)),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        _result.foodName,
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(34)),
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: ScreenAdapter.height(10),
                                        left: ScreenAdapter.width(20)),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "￥${_result.price}",
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(26),
                                            color: Colors.red),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                            padding: EdgeInsets.only(left: ScreenAdapter.width(10)),
                            color: Colors.white,
                            child: Text("   ${_result.remark}",style: TextStyle(letterSpacing: ScreenAdapter.size(2),fontSize: ScreenAdapter.size(26)),textAlign:TextAlign.start,),
                          ) 
                        ],
                      ),
              ),
            ),
            Container(
              height: ScreenAdapter.height(100),
              width: ScreenAdapter.getScreenWidth(),
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[300]))),
              child: Row(
                children: <Widget>[
                  Container(
                    width: ScreenAdapter.getScreenWidth() / 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: ScreenAdapter.width(20)),
                            child: Text("数量："),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (this._count > 1) {
                                setState(() {
                                  this._count--;
                                });
                              }
                            },
                            child: Container(
                              width: ScreenAdapter.width(70),
                              height: ScreenAdapter.height(70),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]),
                                  image: DecorationImage(
                                      image: AssetImage(
                                    "./static/sub.png",
                                  ))),
                            ),
                          ),
                          Container(
                            width: ScreenAdapter.width(70),
                            height: ScreenAdapter.height(70),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.grey[300],
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey[300],
                                    ))),
                            child: Center(
                              child: Text(
                                "$_count",
                                style:
                                    TextStyle(fontSize: ScreenAdapter.size(36)),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                this._count++;
                              });
                            },
                            child: Container(
                              width: ScreenAdapter.width(70),
                              height: ScreenAdapter.height(70),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]),
                                  image: DecorationImage(
                                      image: AssetImage(
                                    "./static/add.png",
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: MyButton(
                        title: "加入购物车",
                        size: 28,
                        onTap: () async{
                          var data={"foodId":widget.foodId,"tableNo":Application.tableNo,"count":_count,"operation":1 };
                          await http.post("${Config.Api.cart_item_edit}",formData:data );
                          var param={"currentIndex":1,"phone":Application.phone,"tableNo":Application.tableNo,"personNum":Application.personNum,"remark":Application.remark};
                          String jsonString = json.encode(param);
                          var jsons = jsonEncode(Utf8Encoder().convert(jsonString));
                          //Provider.of<Order_Information_Provider>(context).setInfo(OrderInformation.fromJson(param));
                          Application.router
                              .navigateTo(
                              context, "/root?params=${jsons}",
                              transition: TransitionType.fadeIn, replace: true)
                              .then((result) {
                            if (result != null) {}
                          });


                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

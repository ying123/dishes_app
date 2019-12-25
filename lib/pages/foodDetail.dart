
import 'dart:convert';
import '../common/widgets/loading.dart';
import '../routers/Routers.dart';
import '../common/provider/user_provider.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import '../routers/Application.dart';
import 'package:flutter/material.dart';
import '../common/ScreenAdapter.dart';
import '../common/config/api_config.dart' as Config;
import '../common/http_util.dart';
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
    HttpUtil.getInstance()
        .get(Config.Api.foodById +"${widget.foodId}")
        .then((res) {
      FoodModel model = FoodModel.fromJson(res);
      setState(() {
        _result = model.result;
        _result.imgUrl="${Config.Api.imgUrl+_result.imgUrl}";
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
                    ? LoadingWidget()
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
                                    fit: BoxFit.cover,
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
                          var model= Provider.of<UserProvider>(context).getUser;
                          var data={"foodId":widget.foodId,"tableNo":model["tableNo"],"count":_count,"operation":1 };
                          await HttpUtil.getInstance().post("${Config.Api.cart_item_edit}",data:data );
                          var param={"currentIndex":1,"phone":model["phone"],"tableNo":model["tableNo"],"personNum":model["personNum"],"remark":model["remark"]};
                          Application.router
                              .navigateTo(
                              context, "${Routers.root}?params=${jsonEncode(Utf8Encoder().convert(json.encode(param)))}",
                              transition: TransitionType.fadeIn, replace: true);
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

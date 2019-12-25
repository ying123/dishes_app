import 'dart:convert';
import '../common/provider/user_provider.dart';
import '../common/utils/toast.dart';
import '../routers/Routers.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/user_storage.dart';
import 'package:flutter/material.dart';
import '../common/ScreenAdapter.dart';
import '../routers/Application.dart';
import 'package:fluro/fluro.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() => _homePage();
}

class _homePage extends State<HomePage> {
  TextEditingController controller;
  DateTime lastPopTime;
  final List _list = [
    {"title": "1人", "checked": true, "p_num": true},
    {"title": "2人", "checked": false, "p_num": true},
    {"title": "3人", "checked": false, "p_num": true},
    {"title": "4人", "checked": false, "p_num": true},
    {"title": "5人", "checked": false, "p_num": true},
    {"title": "6人", "checked": false, "p_num": true},
    {"title": "7人", "checked": false, "p_num": true},
    {"title": "8人", "checked": false, "p_num": true},
    {"title": "9人", "checked": false, "p_num": true},
    {"title": "10人", "checked": false, "p_num": true},
    {"title": "11人", "checked": false, "p_num": true},
    {"title": "12人", "checked": false, "p_num": true},
  ];
  final List _listKw = [
    {"title": "打包带走", "checked": false, "p_mark": true},
    {"title": "不要放辣椒", "checked": false, "p_mark": true},
    {"title": "微辣", "checked": false, "p_mark": true},
  ];
  String _p_num = "1人"; //人数
  String _p_mark = ""; //口味
  String _barcode = "a001";

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this._barcode = barcode);
  }

  _change(int index, List list) {
    for (int i = 0; i < list.length; i++) {
      setState(() {
        list[i]["checked"] = false;
      });
    }
    setState(() {
      list[index]["checked"] = true;
      if (list[index]["p_mark"] == true) {
        if (!_p_mark.contains(list[index]["title"])) {
          _p_mark += " " + list[index]["title"] + " ";
          controller.text = _p_mark;
        }
      } else {
        _p_num = list[index]["title"];
      }
    });
  }

  //遍历创建widget
  List<Widget> _listWidgets(double width, List list) {
    List<Widget> widgets = List();
    for (int i = 0; i < list.length; i++) {
      widgets.add(GestureDetector(
        onTap: () {
          _change(i, list);
        },
        child: Container(
          margin: EdgeInsets.only(
              left: ScreenAdapter.width(20), top: ScreenAdapter.width(20)),
          width: width,
          height: ScreenAdapter.height(100),
          decoration: BoxDecoration(
              border: Border.all(
                  color: list[i]["checked"] ? Colors.red : Colors.grey[300]),
              borderRadius: BorderRadius.circular(6),
              color: list[i]["checked"] ? Colors.red : Colors.white),
          child: Center(
            child: Text(
              list[i]["title"],
              style: TextStyle(
                  fontSize: ScreenAdapter.size(26),
                  color: list[i]["checked"] ? Colors.white : Colors.black),
            ),
          ),
        ),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    //计算每一项的宽度
    double width = ScreenAdapter.getScreenWidth();
    width = (width - ScreenAdapter.width(100)) / 4;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(
            "用餐人数",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: ScreenAdapter.height(80),
                  width: ScreenAdapter.width(200),
                  margin: EdgeInsets.only(top: ScreenAdapter.height(80)),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.black),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(
                              left: ScreenAdapter.width(20),
                              right: ScreenAdapter.width(20)),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "./static/canju.png",
                            width: ScreenAdapter.width(48),
                            height: ScreenAdapter.height(48),
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "用餐人数",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.size(26)),
                          ))
                    ],
                  ),
                ),
                Container(
                  height: ScreenAdapter.height(50),
                  margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                  child: Text(
                    "请选择用餐人数，小二马上为您送餐",
                    style: TextStyle(
                        color: Colors.red, fontSize: ScreenAdapter.size(26)),
                  ),
                ),
                //人数列表

                Container(
                  width: ScreenAdapter.getScreenWidth(),
                  child: Wrap(
                      direction: Axis.horizontal,
                      children: _listWidgets(width, this._list)),
                ),

                Container(
                  margin: EdgeInsets.only(
                      top: ScreenAdapter.height(30),
                      left: ScreenAdapter.width(20),
                      right: ScreenAdapter.width(20)),
                  padding: EdgeInsets.only(
                      left: ScreenAdapter.height(30),
                      right: ScreenAdapter.height(30)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: Colors.grey[300]),
                  ),
                  child: TextField(
                    controller: controller,
                    onChanged: (value) {
                      setState(() {
                        _p_mark = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "请输入您的口味要求，忌口等(可不填)",
                        hintStyle: TextStyle(fontSize: ScreenAdapter.size(26)),
                        border: InputBorder.none),
                  ),
                ),
                //选择口味

                Container(
                  width: ScreenAdapter.getScreenWidth(),
                  child: Wrap(
                      direction: Axis.horizontal,
                      children: _listWidgets(width, this._listKw)),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenAdapter.height(50)),
                  width: ScreenAdapter.width(130),
                  height: ScreenAdapter.height(130),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      //this._barcode = await _scan(); //扫描桌子号
                      var user = await UserStorage.getUser();
                      var params = {
                        "phone": user["phone"],
                        "tableNo": this._barcode,
                        "personNum": this._p_num,
                        "remark": this._p_mark,
                        "currentIndex": 0
                      };
                      Provider.of<UserProvider>(context).setUser(params);
                      Application.router.navigateTo(context,
                          "${Routers.root}?params=${jsonEncode(Utf8Encoder().convert(json.encode(params)))}",
                          transition: TransitionType.fadeIn, replace: true);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "扫码",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "点菜",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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

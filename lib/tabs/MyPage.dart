import 'dart:io';
import 'package:dishes_app/common/config/api_config.dart';
import 'package:dishes_app/common/http_util.dart';
import 'package:dishes_app/services/user_storage.dart';

import '../routers/Application.dart';
import '../routers/Routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../common/ScreenAdapter.dart';
import 'package:image_picker/image_picker.dart';

class MyPage extends StatefulWidget {
  var params;
  MyPage(this.params);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _myPage();
  }
}
class _myPage extends State<MyPage>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("用户中心"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList(context),
        ],
      ),
    );
  }

  File _image;
  String _headImgUrl;
  _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    HttpUtil.getInstance().fileUpload(Api.uploadFile, _image.path,"${widget.params["phone"]}.png",(send,total){
      print("$send===========$total");
    }).then((res){
      print(res);
      setState(() {
        _headImgUrl=res["result"];
      });
    });
  }

  //头像区域
  Widget _topHeader(){
    return Container(
      width: ScreenAdapter.width(750),
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("./static/user_bg.jpg"),
            fit: BoxFit.cover
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenAdapter.height(30)),
            width: ScreenAdapter.height(200),
            height: ScreenAdapter.height(200),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image:_headImgUrl==null?AssetImage("./static/user.png"):NetworkImage("https://www.zlp.ltd/head/$_headImgUrl" )
                )
            ),
            child: GestureDetector(
              onTap: ()async{
                await _getImage();
              },
              child: Image.asset("./static/xiangji.png"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '曾令平',
              style: TextStyle(
                fontSize: ScreenAdapter.size(36),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

    );
  }

  //我的订单标题
  Widget _orderTitle(){
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: ScreenAdapter.size(1),color: Colors.grey[100]),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }


  //我的订单类型
  Widget _orderType(){
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
      width: ScreenAdapter.width(750),
      height: ScreenAdapter.height(150),
      padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenAdapter.width(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.payment,
                  size: ScreenAdapter.size(50),
                ),
                Text("待评价"),//'待付款'
              ],
            ),
          ),
          Container(
            width: ScreenAdapter.width(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  size: ScreenAdapter.size(50),
                ),
                Text("待评价"),//'待发货'
              ],
            ),
          ),
          Container(
            width: ScreenAdapter.width(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  size: ScreenAdapter.size(50),
                ),
                Text("待评价"),//'待收货'
              ],
            ),
          ),
          Container(
            width: ScreenAdapter.width(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.message,
                  size: ScreenAdapter.size(50),
                ),
                Text("待评价"),//'待评价'
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _myListTile(String title,IconData iconData,Object onTab){
    return GestureDetector(
      onTap: onTab,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: ScreenAdapter.size(1),color: Colors.grey[100]),
          ),
        ),
        child: ListTile(
          leading: Icon(iconData),
          title: Text(title),
          trailing: Icon(Icons.arrow_right),
        ),
      ),
    );
  }

  //其它操作列表
  Widget _actionList(BuildContext context ){
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(20),),
      child: Column(
        children: <Widget>[
          _myListTile('修改密码',Icons.https,(){
            Application.router.navigateTo(context, Routers.forgetPwd,transition: TransitionType.fadeIn);
          }),
          _myListTile('我的钱包',Icons.monetization_on,(){

          }),
          _myListTile('退出登录',Icons.phone_forwarded,()async{
            await UserStorage.remove();
            Application.router.navigateTo(context, Routers.userLogin,transition: TransitionType.fadeIn,clearStack: true,replace: true);
          }),
          _myListTile('关于我们',Icons.movie,(){

          }),
        ],
      ),
    );
  }


}


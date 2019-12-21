import 'package:flutter/material.dart';
import '../common/ScreenAdapter.dart';

class MyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("会员中心"),//会员中心
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList(),
        ],
      ),
    );
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

            child: ClipOval(
              child: SizedBox(
                width: ScreenAdapter.height(200),
                height: ScreenAdapter.height(200),
                child: Image.asset('./static/user.png',fit: BoxFit.cover,),
              ),
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


  Widget _myListTile(String title,IconData iconData){
    return Container(
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
    );
  }

  //其它操作列表
  Widget _actionList(){
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(20),),
      child: Column(
        children: <Widget>[
          _myListTile('历史订单',Icons.history),
          _myListTile('我的钱包',Icons.monetization_on),
          _myListTile('客服电话',Icons.phone_forwarded),
          _myListTile('关于我们',Icons.movie),
        ],
      ),
    );
  }


}


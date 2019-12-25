
import 'package:flutter/material.dart';
import '../common/ScreenAdapter.dart';
import 'search.dart';
import 'dotGreens.dart';
import 'hotSale.dart';

class Food extends StatefulWidget {
  var params;
  Food({this.params});
  @override
  State<StatefulWidget> createState() => _Food();
}

class _Food extends State<Food> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  TabController _tabController;
  List<Widget> _tabs=[
    Tab(
      text: "热销榜",
      icon: Image.asset(
        "./static/rexiao.png",
        width: ScreenAdapter.width(40),
        height: ScreenAdapter.height(40),
      ),
    ),
    Tab(
      text: "点过的菜",
      icon: Image.asset(
        "./static/book.png",
        width: ScreenAdapter.width(40),
        height: ScreenAdapter.height(40),
      ),
    ),
    Tab(
      text: "搜你喜欢",
      icon: Image.asset(
        "./static/sousuo.png",
        width: ScreenAdapter.width(40),
        height: ScreenAdapter.height(40),
      ),
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenAdapter.init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("点餐首页"),
          leading: null,
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: _tabs
          ),
        ),
        body: TabBarView(
          //禁止滑动切换
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[HotSale(), DotGreens(), Search()],
        ));
  }
}

import 'package:dishes_app/pages/order/hist_order.dart';
import 'package:dishes_app/pages/order/today_order.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget{
  String phone;
  OrderPage(this.phone);
  @override
  State<StatefulWidget> createState() =>_OrderPage();

}
class _OrderPage extends State<OrderPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  final List<Tab> _tabs = <Tab>[
    Tab(
      text: '今日订单',
    ),
    Tab(
      text: '历史订单',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController=TabController(length: _tabs.length, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的订单"),
        centerTitle: true,
        bottom: TabBar(
          tabs: _tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          TodayOrder(widget.phone),
          HistOrder(widget.phone),
        ],
      ),
    );
  }

}

import 'package:dishes_app/common/ScreenAdapter.dart';
import 'package:dishes_app/common/config/api_config.dart';
import 'package:dishes_app/common/http_util.dart';
import 'package:dishes_app/model/order.dart';
import 'package:dishes_app/model/order_hist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodayOrder extends StatefulWidget{
  String phone;
  TodayOrder(this.phone);
  @override
  State<StatefulWidget> createState() =>_TodayOrder();
}
class _TodayOrder extends State<TodayOrder> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  List<OrderHist> _orders=[];
  @override
  void initState() {
    super.initState();
    _initData();
  }
  _initData()async{
    await HttpUtil.getInstance().get(Api.todayOrder+widget.phone).then((res){
      List<OrderHist> data=[];
      res["result"].forEach((v) {
        data.add(OrderHist.fromJson(v));
      });
      setState(() {
        _orders=data;
        mList=new List();
        expandStateList=new List();
        for(int i=0;i<_orders.length;i++){
          mList.add(i);
          expandStateList.add(ExpandStateBean(i,false));//item初始状态为闭着的
        }
      });
    });
  }
  List<int> mList=List();   //组成一个int类型数组，用来控制索引
  List<ExpandStateBean> expandStateList=List();  //展开的状态列表,ExpandStateBean是自定义的类
  //修改展开与闭合的内部方法
  _setCurrentIndex(int index){
    setState(() {
      //遍历可展开状态列表
      expandStateList.forEach((item){
        item.isOpen=false;
      });
      expandStateList[index].isOpen=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: ExpansionPanelList(
          expansionCallback: (index,bol){
            //调用内部方法
            _setCurrentIndex(index);
          },
          children: mList.map((index){
            //返回一个组成的ExpansionPanel
            return ExpansionPanel(
                headerBuilder: (context,isExpanded){
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text("${_orders[index].orderTime}",style: TextStyle(fontSize: ScreenAdapter.size(26)),),
                        ),
                        Expanded(
                          child: Text("￥${_orders[index].price}",style: TextStyle(fontSize: ScreenAdapter.size(26),color: Colors.red),),
                        ),
                      ],
                    ),
                  );
                },
                body: Container(
                  margin: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                  padding: EdgeInsets.all(ScreenAdapter.size(10)),
                  child: Column(
                    children: <Widget>[
                      Table(
                        border: TableBorder.all(color: Colors.grey[200],width: ScreenAdapter.size(1)),
                        children:[
                          TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Text("菜品"),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text("价格"),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text("数量"),
                                ),
                              ),
                            ]
                          )
                        ]
                      ),
                      Table(
                        border: TableBorder.all(color: Colors.grey[200],width: ScreenAdapter.size(1)),
                        children: _orders[index].details.map((item){
                          return TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Text(item.foodName,style: TextStyle(fontSize: ScreenAdapter.size(24)),),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(item.price.toString(),style: TextStyle(fontSize: ScreenAdapter.size(24)),),
                                  ),
                                ),
                                TableCell(
                                  child: Center(
                                    child: Text(item.count.toString(),style: TextStyle(fontSize: ScreenAdapter.size(24)),),
                                  ),
                                ),
                              ]
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                ),
                isExpanded: expandStateList[index].isOpen
            );
          }).toList(),
        ),
      ),
    );
  }
}
//list中item状态自定义类
class ExpandStateBean{
  var isOpen;   //item是否打开
  var index;    //item中的索引
  ExpandStateBean(this.index,this.isOpen);
}
import 'package:dishes_app/common/config/api_config.dart';
import 'package:dishes_app/common/provider/order_provider.dart';
import 'package:dishes_app/model/order.dart';
import 'package:dishes_app/routers/Routers.dart';
import 'package:provider/provider.dart';
import '../common/widgets/loading.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';
import '../common/ScreenAdapter.dart';
import '../common/http_util.dart';
import '../common/config/api_config.dart' as Config;
import '../routers/Application.dart';
class FoodPage extends StatefulWidget {
  @override
  _FoodPage createState() => _FoodPage();
}

class _FoodPage extends State<FoodPage> with AutomaticKeepAliveClientMixin {
  //页面状态保持，重写此方法
  @override
  bool get wantKeepAlive => true;
  ScrollController _scrollController;
  var _futureBuilderFuture;
  List<FoodModel> _foodList=[];
    //首页数据
  Future _getFoodList() async{
     var response= await HttpUtil.getInstance().get(Config.Api.cateGroyList);
     List<CateGroy> list=CateGroyModel.fromJson(response).result;
     list[0].checked=true;
     _foodList=list[0].foodList;
    return list;
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    ///用_futureBuilderFuture来保存_gerData()的结果，以避免不必要的ui重绘
    _futureBuilderFuture = _getFoodList();
  }

  //菜品列表
  _listWidget(double width) {
    List<Widget> widgets=[];
    _foodList.forEach((item){
      widgets.add( Container(
        width: width,
        height: ScreenAdapter.height(260),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenAdapter.size(8))),
        margin: EdgeInsets.only(
            left: ScreenAdapter.width(10), top: ScreenAdapter.height(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Application.router.navigateTo(context, "${Routers.foodDetail}?foodId=${item.foodId}");
              },
              child: Container(
                height: ScreenAdapter.height(150),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "${Api.imgUrl+item.imgUrl}"))),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  item.foodName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenAdapter.size(26),),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "￥${item.price}",
                          style: TextStyle(fontSize: ScreenAdapter.size(26)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        OrderModel model= Provider.of<OrderProvider>(context).getOrder;
                        if(model.tableNo ==null){
                          Application.router.navigateTo(context, Routers.home,replace: true,clearStack: true);
                        }else{
                          var data={"foodId":item.foodId,"tableNo":model.tableNo,"count":1,"operation":1 };
                          await HttpUtil.getInstance().post("${Config.Api.cart_item_edit}",data:data );
                        }
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.add_circle,size: ScreenAdapter.size(46),color: Colors.green,),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),);
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("菜品列表"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: _buildFuture,
      ),
    );
  }
  ///snapshot就是_calculation在时间轴上执行过程的状态快照
  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    //计算容器宽度
    double contentWidth = ScreenAdapter.getScreenWidth();
    contentWidth = (contentWidth - ScreenAdapter.width(240)) / 3;
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return LoadingWidget();
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _initBuildWidget(contentWidth, snapshot.data);
      default:
        return Text('还没有开始网络请求');
    }
  }

  _initBuildWidget(double contentWidth,List<CateGroy> cateList){
    return Row(
      children: <Widget>[
        Container(
          width: ScreenAdapter.width(200),
          decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey[200]))),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: cateList.length,
            //预设高度，优化加载速度
            itemExtent: ScreenAdapter.height(100),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  cateList.forEach((item){
                    setState(() {
                      item.checked = false;
                    });
                  });
                  setState(() {
                    cateList[index].checked = true;
                    _foodList=cateList[index].foodList;
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: cateList[index].checked
                            ? Colors.green[200]
                            : Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: Center(
                      child: Text(
                        cateList[index].categroyName,
                        style: TextStyle(
                          fontSize: ScreenAdapter.size(24),
                          color: cateList[index].checked
                              ? Colors.white
                              : Colors.black54,
                        ),
                      ),
                    )),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.topLeft,
            color: Color.fromRGBO(247, 247, 247, 0.0),
            child: Wrap(children: _listWidget(contentWidth)),
          ),
        )
      ],
    );
  }
}

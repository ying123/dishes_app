import '../common/widgets/loading.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';
import '../common/ScreenAdapter.dart';
import '../common/Http.dart' as Http;
import '../common/config/Config.dart' as Config;
import '../routers/Application.dart';
class HotSale extends StatefulWidget {
  @override
  _HotSale createState() => _HotSale();
}

class _HotSale extends State<HotSale> {
  ScrollController _scrollController;
  List<CateGroy> _cateGroyList = [];//分类数据
  CateGroy _cateGroy;
    //首页数据
  _getFoodList() async{
     await Http.get(Config.Api.cateGroyList).then((res) {
      CateGroyModel model=CateGroyModel.fromJson(res);
      setState(() {
        _cateGroyList=model.result;
        _cateGroyList[0].checked=true;
        _cateGroy=_cateGroyList[0];
      });

    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getFoodList();
    _scrollController = ScrollController();
  }

  //菜品列表
  _listWidget(CateGroy cateGroy, double width) {
    List<Widget> _widgets = [];
    if (cateGroy == null) {
      _widgets.add(
        Center(
          child: LoadingWidget(),
        )

      );
    } else {
      for (int i = 0; i < cateGroy.foodList.length; i++) {
        _widgets.add(
          GestureDetector(
            onTap: (){
              Application.router.navigateTo(context, "/foodDetail?foodId=${cateGroy.foodList[i].foodId}");
            },
            child: Container(
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
                  Container(
                    height: ScreenAdapter.height(150),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://www.zlp.ltd/images/${cateGroy.foodList[i].imgUrl}"))),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        cateGroy.foodList[i].foodName,
                        style: TextStyle(fontSize: ScreenAdapter.size(26)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "￥${cateGroy.foodList[i].price}",
                        style: TextStyle(fontSize: ScreenAdapter.size(26)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    //计算容器宽度
    double contentWidth = ScreenAdapter.getScreenWidth();
    contentWidth = (contentWidth - ScreenAdapter.width(240)) / 3;
    return Row(
      children: <Widget>[
        Container(
          width: ScreenAdapter.width(200),
          decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey[100]))),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _cateGroyList.length,
            //预设高度，优化加载速度
            itemExtent: ScreenAdapter.height(100),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  for (var i = 0; i < _cateGroyList.length; i++) {
                    setState(() {
                      _cateGroyList[i].checked = false;
                    });
                  }
                  setState(() {
                    _cateGroyList[index].checked = true;
                    this._cateGroy=_cateGroyList[index];
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: _cateGroyList[index].checked
                            ? Colors.green[100]
                            : Colors.white,
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: Center(
                      child: Text(
                        _cateGroyList[index].categroyName,
                        style: TextStyle(
                          fontSize: ScreenAdapter.size(24),
                          color: _cateGroyList[index].checked
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
            child: Wrap(children: _listWidget(this._cateGroy, contentWidth)),
          ),
        )
      ],
    );
  }
}

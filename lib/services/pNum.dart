import '../common/Storage.dart';
import 'dart:convert';
class PNum{
  static setPnum(value) async{
    /*
          1、获取本地存储里面的数据  

          2、判断本地存储是否有数据

              2.1、如果有数据 

                    1、读取本地存储的数据
                    2、判断本地存储中有没有当前数据，
                        如果有不做操作、
                        如果没有当前数据,本地存储的数据和当前数据拼接后重新写入           


              2.2、如果没有数据

                    直接把当前数据放在数组中写入到本地存储
      
      
      */

    try {
      await Storage.setString('p_num', json.encode(value));
      
    } catch (e) {
      
      await Storage.setString('p_num', json.encode(value));
    }
    
  }
  static getPNum() async{
    try {
      var searchListData = json.decode(await Storage.getString('p_num'));
      print("正常");
      return searchListData;
    } catch (e) {
      print("报错");
      return "出错啦";
    }
  }
}
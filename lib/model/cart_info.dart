class OrderInfoModel {
  String code;
  List<OrderInfo> result;

  OrderInfoModel({this.code, this.result});

  OrderInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<OrderInfo>();
      json['result'].forEach((v) {
        result.add(new OrderInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderInfo {
  String tableNo;
  int foodId;
  int count;
  String foodName;
  double price;
  String imgUrl;
  String code;
  OrderInfo(
      {this.tableNo,
        this.foodId,
        this.count,
        this.foodName,
        this.price,
        this.imgUrl,
        this.code});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    tableNo = json['tableNo'];
    foodId = json['foodId'];
    count = json['count'];
    foodName = json['foodName'];
    price = double.parse(json['price']) ;
    imgUrl = json['imgUrl'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableNo'] = this.tableNo;
    data['foodId'] = this.foodId;
    data['count'] = this.count;
    data['foodName'] = this.foodName;
    data['price'] = this.price;
    data['imgUrl'] = this.imgUrl;
    data['code'] = this.code;
    return data;
  }
}

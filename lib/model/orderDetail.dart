class OrderDetailModel {
  String code;
  List<OrderDetail> data;

  OrderDetailModel({this.code, this.data});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = new List<OrderDetail>();
      json['data'].forEach((v) {
        data.add(new OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetail {
  int foodId;
  int count;
  String foodName;
  String imgUrl;
  int price;

  OrderDetail({this.foodId, this.count, this.foodName, this.imgUrl, this.price});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    foodId = json['foodId'];
    count = json['count'];
    foodName = json['foodName'];
    imgUrl = json['imgUrl'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodId'] = this.foodId;
    data['count'] = this.count;
    data['foodName'] = this.foodName;
    data['imgUrl'] = this.imgUrl;
    data['price'] = this.price;
    return data;
  }
}

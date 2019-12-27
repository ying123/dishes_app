class OrderHist {
  String orderId;
  String orderTime;
  double price;
  List<Details> details;

  OrderHist({this.orderId, this.orderTime, this.price, this.details});

  OrderHist.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderTime = json['orderTime'];
    price = json['price'];
    if (json['details'] != null) {
      details = new List<Details>();
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderTime'] = this.orderTime;
    data['price'] = this.price;
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String foodName;
  double price;
  int count;

  Details({this.foodName, this.price, this.count});

  Details.fromJson(Map<String, dynamic> json) {
    foodName = json['foodName'];
    price = json['price'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodName'] = this.foodName;
    data['price'] = this.price;
    data['count'] = this.count;
    return data;
  }
}

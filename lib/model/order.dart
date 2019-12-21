class OrderModel {
  String orderId;
  String personNum;
  String tableNo;
  String person;
  String orderTime;
  int price;
  String remark;
  Null overtime;

  OrderModel(
      {this.orderId,
        this.personNum,
        this.tableNo,
        this.person,
        this.orderTime,
        this.price,
        this.remark,
        this.overtime});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    personNum = json['personNum'];
    tableNo = json['tableNo'];
    person = json['person'];
    orderTime = json['orderTime'];
    price = json['price'];
    remark = json['remark'];
    overtime = json['overtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['personNum'] = this.personNum;
    data['tableNo'] = this.tableNo;
    data['person'] = this.person;
    data['orderTime'] = this.orderTime;
    data['price'] = this.price;
    data['remark'] = this.remark;
    data['overtime'] = this.overtime;
    return data;
  }
}

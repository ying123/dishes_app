class CateGroyModel {
  String code;
  List<CateGroy> result;

  CateGroyModel({this.code, this.result});

  CateGroyModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = new List<CateGroy>();
      json['result'].forEach((v) {
        result.add(new CateGroy.fromJson(v));
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

class CateGroy {
  int categroyId;
  String categroyName;
  String remark;
  bool checked=false;
  List<FoodModel> foodList;

  CateGroy({this.categroyId, this.categroyName, this.remark, this.foodList});

  CateGroy.fromJson(Map<String, dynamic> json) {
    categroyId = json['categroyId'];
    categroyName = json['categroyName'];
    remark = json['remark'];
    if (json['foodList'] != null) {
      foodList = new List<FoodModel>();
      json['foodList'].forEach((v) {
        foodList.add(new FoodModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categroyId'] = this.categroyId;
    data['categroyName'] = this.categroyName;
    data['remark'] = this.remark;
    if (this.foodList != null) {
      data['foodList'] = this.foodList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodModel {
  int foodId;
  String foodName;
  int categroyId;
  Null categroyName;
  double price;
  String imgUrl;
  String remark;

  FoodModel(
      {this.foodId,
        this.foodName,
        this.categroyId,
        this.categroyName,
        this.price,
        this.imgUrl,
        this.remark});

  FoodModel.fromJson(Map<String, dynamic> json) {
    foodId = json['foodId'];
    foodName = json['foodName'];
    categroyId = json['categroyId'];
    categroyName = json['categroyName'];
    price = json['price'];
    imgUrl = json['imgUrl'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodId'] = this.foodId;
    data['foodName'] = this.foodName;
    data['categroyId'] = this.categroyId;
    data['categroyName'] = this.categroyName;
    data['price'] = this.price;
    data['imgUrl'] = this.imgUrl;
    data['remark'] = this.remark;
    return data;
  }
}

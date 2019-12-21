class FoodModel {
  String code;
  Food result;

  FoodModel({this.code, this.result});

  FoodModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result =
    json['result'] != null ? new Food.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Food {
  int foodId;
  String foodName;
  int categroyId;
  Null categroyName;
  double price;
  String imgUrl;
  String remark;

  Food(
      {this.foodId,
        this.foodName,
        this.categroyId,
        this.categroyName,
        this.price,
        this.imgUrl,
        this.remark});

  Food.fromJson(Map<String, dynamic> json) {
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

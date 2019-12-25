class UserModel {
  String phone;
  String pwd;
  String userName;
  int roleId;
  String code;
  String token;
  String tableNo;
  String personNum;
  String remark;
  int currentIndex;
  int foodId;
  UserModel(
      {this.phone,
        this.foodId,
        this.currentIndex,
        this.pwd,
        this.userName,
        this.roleId,
        this.code,
        this.tableNo,
        this.personNum,
        this.remark,
        this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    pwd = json['pwd'];
    userName = json['userName'];
    roleId = json['roleId'];
    code = json['code'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['pwd'] = this.pwd;
    data['userName'] = this.userName;
    data['roleId'] = this.roleId;
    data['code'] = this.code;
    data['token'] = this.token;
    return data;
  }
}

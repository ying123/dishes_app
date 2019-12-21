class UserModel {
  String code;
  User user;

  UserModel({this.code, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    user =
    json['result'] != null ? new User.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.user != null) {
      data['result'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String phone;
  String pwd;
  String userName;
  int roleId;

  User({this.phone, this.pwd, this.userName, this.roleId});

  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    pwd = json['pwd'];
    userName = json['userName'];
    roleId = json['roleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['pwd'] = this.pwd;
    data['userName'] = this.userName;
    data['roleId'] = this.roleId;
    return data;
  }
}

import 'dart:convert';
import 'package:dishes_app/common/widgets/textfield.dart';
import 'package:dishes_app/services/myTextField.dart';

import '../../services/pNum.dart';
import 'package:fluro/fluro.dart';
import '../../services/user_storage.dart';
import '../../model/users.dart';
import '../../routers/Application.dart';

import '../../common/widgets/MyButton.dart';
import '../../common/utils/toast.dart';
import '../../common/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import '../../common/config/Config.dart' as Config;
import '../../common/Http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title,this.params}) : super(key: key);
  final String title;
  String params;
  @override
  State<StatefulWidget> createState() {
    return _loginPage();
  }
}


class _loginPage extends State<LoginPage> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();
  var _params;
  @override
  void initState() {
    super.initState();
    _utf8Decoder();
    _pwdController = TextEditingController();
    _phoneController = TextEditingController();
    _pwdController.addListener(() => setState(() => {}));
    _phoneController.addListener(() => setState(() => {}));
  }

  _utf8Decoder(){
    var list = List<int>();
    ///字符串解码
    jsonDecode(widget.params).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    _params = json.decode(value);
  }

  //登录
  _login(phone,pwd)async{
    await http.post("${Config.Api.host}${Config.Api.userLogin}", formData: {"phone": phone, "pwd": pwd}).then((res){
      UserModel model=UserModel.fromJson(res);
      UserStorage.setUser(model.user);//保存在本地
      Application.tableNo=_params["tableNo"];
      Application.personNum=_params["personNum"];
      Application.remark=_params["remark"];
      Application.phone=model.user.phone;
      var param={"currentIndex":0,"phone":model.user.phone,"tableNo":_params["tableNo"],"personNum":_params["personNum"],"remark":_params["remark"]};
      String jsonString = json.encode(param);
      var jsons = jsonEncode(Utf8Encoder().convert(jsonString));
      Application.router
          .navigateTo(
          context, "/root?params=${jsons}",
          transition: TransitionType.fadeIn, replace: true)
          .then((result) {
        if (result != null) {}
      });
    });
  }

  Widget _logo() {
    return Center(
      child: Container(
        width: ScreenAdapter.width(280),
        height: ScreenAdapter.height(320),
        margin: EdgeInsets.only(top: ScreenAdapter.size(20)),
        alignment: Alignment.center,
        child: ClipOval(
          child: Image.network(
            "http://www.zlp.ltd/images/touxiang.png",
            width: ScreenAdapter.width(250),
            height: ScreenAdapter.width(250),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("登陆/注册"),
        centerTitle: true,
        leading: Text(""),
      ),
      body: Container(
          margin: EdgeInsets.all(ScreenAdapter.width(10)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _logo(),
                _buildEditWidget(),
                _buildLoginRegisterButton(),
              ],
            ),
          )),
    );
  }

  //输入框
  _buildEditWidget() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenAdapter.size(15),
          right: ScreenAdapter.size(15),
          top: ScreenAdapter.size(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenAdapter.size(6.0)),
        border: Border.all(width: ScreenAdapter.size(1), color: Colors.black12),
      ),
      child: Column(
        children: <Widget>[
          //手机号码输入框
          MyTextWidget(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            hintText: "请输入手机号码",
            prefixIcon: Icons.phone,
            inputType: TextInputType.phone,
          ),
          //_buildLoginNameTextField(),
          Divider(height: 1),
          _buildPwdTextField(),
//          MyTextWidget(
//            controller: _pwdController,
//            focusNode: _pwdFocusNode,
//            hintText: "请输入密码",
//            prefixIcon: Icons.https,
//            isPwd: true,
//          ),
          //_buildPwdTextField(),
        ],
      ),
    );
  }

//  _buildLoginNameTextField() {
//    return TextFormField(
//      keyboardType: TextInputType.number,
//      controller: _userNameEditController,
//      focusNode: _userNameFocusNode,
//      decoration: InputDecoration(
//        hintText: "手机号",
//        hintStyle: TextStyle(fontSize: ScreenAdapter.size(28)),
//        border: InputBorder.none,
//        prefixIcon: Icon(
//          Icons.add_call,
//          color: Colors.grey,
//        ),
//        suffixIcon: (_userNameEditController.text ?? null).isEmpty
//            ? Text("")
//            : IconButton(
//                icon: Icon(
//                  Icons.cancel,
//                  color: Colors.grey,
//                ),
//                onPressed: () {
//                  _userNameEditController.clear();
//                  _userNameFocusNode.unfocus();
//                }),
//      ),
//    );
//  }

  _buildPwdTextField() {
    return TextField(
        controller: _pwdController,
        focusNode: _pwdFocusNode,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "密码",
          hintStyle: TextStyle(fontSize: ScreenAdapter.size(28)),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.https,
            color: Colors.grey,
          ),
          suffixIcon: (_pwdController.text ?? "").isEmpty
              ? FlatButton(
                  child: Text(
                    "忘记密码",
                    style: TextStyle(fontSize: ScreenAdapter.size(28)),
                  ),
                  onPressed: () {
                    _pwdFocusNode.unfocus();
                    Application.router.navigateTo(context, "/userForgetPwd");
                  })
              : IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      _pwdController.clear();
                      _pwdFocusNode.unfocus();
                    });

                  }),
        ));
  }

  _buildLoginRegisterButton() {
    return Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
      padding: EdgeInsets.all(ScreenAdapter.size(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: MyButton(
              title: "登录",
              onTap: () async {
                if (_phoneController.text.isEmpty) {
                  Toast.toast(context, msg: "请输入电话号码");
                  return;
                }
                var phone = RegExp(
                    '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
                if (!phone.hasMatch(_phoneController.text)) {
                  Toast.toast(context, msg: "请输入正确的手机号");
                  return;
                }
                if (_pwdController.text.isEmpty) {
                  Toast.toast(context, msg: "请输入密码");
                  return;
                }
                //登录
                _login(_phoneController.text, _pwdController.text);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: MyButton(
              title: "注册",
              color: Colors.green[300],
              onTap: () {
                Application.router
                    .navigateTo(context, "/userRegister")
                    .then((result) => {});
              },
            ),
          )
        ],
      ),
    );
  }
}

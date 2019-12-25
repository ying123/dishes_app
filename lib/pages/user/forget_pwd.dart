import 'dart:async';
import '../../common/config/constant.dart';
import '../../common/config/my_text.dart';
import '../../common/provider/user_provider.dart';
import '../../model/users.dart';
import '../../routers/Application.dart';
import '../../routers/Routers.dart';
import '../../services/user_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import '../../common/utils/toast.dart';
import '../../common/widgets/MyButton.dart';
import '../../common/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import '../../common/http_util.dart';
import '../../common/config/api_config.dart' as Config;

class ForgetPwd extends StatefulWidget {
  _ForgetPwd createState() => _ForgetPwd();
}

class _ForgetPwd extends State<ForgetPwd> {
  TextEditingController _phone; //手机号
  TextEditingController _code; //验证码
  TextEditingController _pwd; //密码
  FocusNode _phoneFocus = FocusNode();
  FocusNode _codeFocus = FocusNode();
  FocusNode _pwdFocus = FocusNode();

  //防止多次点击
  bool _isButtonDisabled;
  /// 当前倒计时的秒数。
  int _seconds = 60;
  /// 倒计时的计时器。
  Timer _timer;
  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        setState(() {
          _isButtonDisabled = true;
          _seconds = 60;
        });
        return;
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }
  /// 取消倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _phone = TextEditingController();
    _code = TextEditingController();
    _pwd = TextEditingController();
    _phone.addListener(() => setState(() => {}));
    _code.addListener(() => setState(() => {}));
    _pwd.addListener(() => setState(() => {}));
    _isButtonDisabled = true;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();

  }


  //封装当前页面输入框
  Widget _buildTextField(hintText, controller, focusNode, textInputType, icon) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      focusNode: focusNode,
      onSaved: (String value) => controller.text = value,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: ScreenAdapter.size(28)),
        border: InputBorder.none,
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        suffixIcon: (controller.text ?? null).isEmpty
            ? Text("")
            : IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.clear();
                    focusNode.unfocus();
                  });
                }),
      ),
    );
  }

  Widget _incrementCounter() {
    if (_isButtonDisabled) {
      return FlatButton(
          onPressed: () {
            if (_phone.text.isEmpty) {
              Toast.toast(context, msg: "请输入手机号");
              return;
            }
            var phone = RegExp(Constant.REG_EXP);
            if (!phone.hasMatch(_phone.text.trim())) {
              Toast.toast(context, msg: "手机号码格式不正确");
              return;
            }
            _startTimer();
            setState(() {
              _isButtonDisabled = false;
            });
            HttpUtil.getInstance().get("${Config.Api.getCode}${_phone.text}").then((res){
              Toast.toast(context,msg: "验证码：${res[Constant.result]}");
            });
          },
          child: Text(MyText.codeName, style: TextStyle(
                color: Color.fromARGB(255, 145, 41, 40),
                fontSize: ScreenAdapter.size(30)),
          ));
    } else {
      return FlatButton(
          onPressed: null,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 5,right: 5),
                child: Text("${_seconds.toString()}s后重新发送",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: ScreenAdapter.size(26))),
              ),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.FORGET_PWD),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(ScreenAdapter.width(10)),
        padding: EdgeInsets.all(ScreenAdapter.width(10)),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(100),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12),
                  borderRadius: BorderRadius.circular(6)),
              child: _buildTextField("手机号", this._phone,
                  this._phoneFocus, TextInputType.number, Icons.phone),
            ),
            Container(
                margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(100),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.circular(6)),
                child: Stack(
                  children: <Widget>[
                    _buildTextField("验证码", this._code, this._codeFocus,
                        TextInputType.number, Icons.verified_user),
                    Positioned(
                      right: ScreenAdapter.width(50),
                      child: _incrementCounter(),
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
              width: ScreenAdapter.width(750),
              height: ScreenAdapter.height(100),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12),
                  borderRadius: BorderRadius.circular(6)),
              child: _buildTextField("新密码", this._pwd, this._pwdFocus,
                  TextInputType.emailAddress, Icons.https),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(50)),
              child: MyButton(
                title: "确定",
                color: Color.fromARGB(255, 145, 41, 40),
                width: double.infinity,
                onTap: () {
                  if (_phone.text.isEmpty) {
                    Toast.toast(context, msg: "请输入手机号");
                    return;
                  }
                  var phone = RegExp(Constant.REG_EXP);
                  if (!phone.hasMatch(_phone.text.trim())) {
                    Toast.toast(context, msg: "手机号格式错误");
                    return;
                  }
                  if (_code.text.isEmpty) {
                    Toast.toast(context, msg: "请输入6位数字验证码");
                    return;
                  }
                  if (_pwd.text.isEmpty) {
                    Toast.toast(context, msg: "请输入密码");
                    return;
                  }
                  var params={Constant.phone:_phone.text.trim(),Constant.code:_code.text.trim(),Constant.pwd:_pwd.text.trim()};
                  HttpUtil.getInstance().post(Config.Api.updatePwd,data: params).then((res){
                    switch(res[Constant.code]){
                      case Constant.success:
                        _success();
                        break;
                      case Constant.code_not_match:
                        Toast.toast(context, msg: "验证码不匹配");
                        break;
                      case Constant.error:
                        Toast.toast(context, msg: "服务器错误，请联系管理员");
                        break;
                      case Constant.code_past:
                        Toast.toast(context, msg: "验证码已过期");
                        break;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  _success() async{
    var user={Constant.phone:_phone.text.trim(),Constant.pwd:_pwd.text.trim()};
    await HttpUtil.getInstance().post("${Config.Api.host}${Config.Api.login}", data: user).then((res){
      UserModel user= UserModel.fromJson(res[Constant.result]);
      UserStorage.setUser(user);
      Application.token=user.token;
      Provider.of<UserProvider>(context).setUser(res[Constant.result]);
      Application.router.navigateTo(context, Routers.home,replace: true,clearStack: true,transition: TransitionType.fadeIn);
    });
  }
}

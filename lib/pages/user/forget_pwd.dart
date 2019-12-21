import 'dart:async';
import '../../common/utils/toast.dart';
import '../../common/widgets/MyButton.dart';
import '../../common/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import '../../common/Http.dart' as http;
import '../../common/config/Config.dart' as config;

class ForgetPwd extends StatefulWidget {
  _ForgetPwd createState() => _ForgetPwd();
}

class _ForgetPwd extends State<ForgetPwd> {
  TextEditingController _phone; //手机号
  TextEditingController _code; //验证码
  TextEditingController _pwd; //验证码
  FocusNode _phoneFocus = FocusNode();
  FocusNode _codeFocus = FocusNode();
  FocusNode _pwdFocus = FocusNode();
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
    super.dispose();
    _cancelTimer();
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  Widget _buildLoginNameTextField(
      hintText, controller, focusNode, textInputType, icon) {
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
            if (_phone.text == "") {
              Toast.toast(context, msg: "请输入手机号");
              return;
            }
            var phone = RegExp(
                '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
            if (!phone.hasMatch(_phone.text)) {
              Toast.toast(context, msg: "请输入正确的手机号");
              return;
            }
            _startTimer();

            setState(() {
              _isButtonDisabled = false;
            });
          },
          child: Text(
            "获取验证码",
            style: TextStyle(
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
        title: Text("忘记密码"),
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
              child: _buildLoginNameTextField("手机号", this._phone,
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
                    _buildLoginNameTextField("验证码", this._code, this._codeFocus,
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
              child: _buildLoginNameTextField("新密码", this._pwd, this._pwdFocus,
                  TextInputType.emailAddress, Icons.https),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenAdapter.height(50)),
              child: MyButton(
                title: "确定",
                color: Color.fromARGB(255, 145, 41, 40),
                width: double.infinity,
                onTap: () {
                  if (_phone.text == "") {
                    Toast.toast(context, msg: "请输入手机号");
                    return;
                  }
                  var phone = RegExp(
                      '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
                  if (!phone.hasMatch(_phone.text)) {
                    Toast.toast(context, msg: "请输入正确的手机号");
                    return;
                  }
                  if (_code.text == "") {
                    Toast.toast(context, msg: "请输入6位数字验证码");
                    return;
                  }
                  if (_pwd.text == "") {
                    Toast.toast(context, msg: "请输入密码");
                    return;
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/services.dart';

import '../../common/config/constant.dart';
import '../../common/config/my_text.dart';
import '../../routers/Routers.dart';
import '../../services/user_storage.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import '../../common/provider/user_provider.dart';
import '../../common/widgets/textfield.dart';
import '../../model/users.dart';
import '../../routers/Application.dart';
import '../../common/widgets/MyButton.dart';
import '../../common/utils/toast.dart';
import '../../common/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import '../../common/config/api_config.dart' as Config;
import '../../common/http_util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_loginPage();

}
class _loginPage extends State<LoginPage> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();
  DateTime lastPopTime;
  @override
  void initState() {
    super.initState();
//    _utf8Decoder();
    _pwdController = TextEditingController();
    _phoneController = TextEditingController();
    _pwdController.addListener(() => setState(() => {}));
    _phoneController.addListener(() => setState(() => {}));
  }

  //登录
  _login(phone,pwd)async{
     await HttpUtil.getInstance().post("${Config.Api.host+Config.Api.login}", data: {Constant.phone: phone, Constant.pwd: pwd}).then((res){
       if(res[Constant.code]==Constant.success){
         if(res[Constant.result]==null){
           Toast.toast(context,msg: "用户名密码错误");
         }else{
           UserModel user= UserModel.fromJson(res[Constant.result]);
           UserStorage.setUser({Constant.phone: phone, Constant.pwd: pwd,"token":user.token});//用户名密码存本地
           Application.token=user.token;
           Provider.of<UserProvider>(context).setUser(res[Constant.result]);
           Application.router.navigateTo(context, Routers.home,replace: true,transition: TransitionType.fadeIn);
         }
       }
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
            "${Config.Api.imgUrl}touxiang.png",
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
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(MyText.LOGIN),
          centerTitle: true,
          leading: Text(""),
        ),
        body: Container(
            margin: EdgeInsets.all(ScreenAdapter.width(10)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _logo(),
                  _phoneTextField(),
                  _buildLoginRegisterButton(),
                ],
              ),
            )),
      ),
      onWillPop: ()async {
        if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)){
          lastPopTime = DateTime.now();
          Toast.toast(context,msg: '再按一次退出');
          return false;
        }else{
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }

  //手机号输入框
  _phoneTextField() {
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
          _pwdTextField(),
        ],
      ),
    );
  }

  //密码输入框
  _pwdTextField() {
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
                    MyText.FORGET_PWD,
                    style: TextStyle(fontSize: ScreenAdapter.size(28)),
                  ),
                  onPressed: () {
                    _pwdFocusNode.unfocus();
                    Application.router.navigateTo(context, Routers.forgetPwd);
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

  //登录，注册按钮
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
                var phone = RegExp(Constant.REG_EXP);
                if (!phone.hasMatch(_phoneController.text.trim())) {
                  Toast.toast(context, msg: "请输入正确的手机号");
                  return;
                }
                if (_pwdController.text.isEmpty) {
                  Toast.toast(context, msg: "请输入密码");
                  return;
                }
                //登录
                _login(_phoneController.text.trim(), _pwdController.text.trim());
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: MyButton(
              title: "注册",
              color: Colors.green[300],
              onTap: () {
                Application.router.navigateTo(context, Routers.userRegister);
              },
            ),
          )
        ],
      ),
    );
  }
}

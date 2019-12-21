import 'package:flutter/material.dart';
import '../../common/ScreenAdapter.dart';
class MyTextWidget extends StatelessWidget{
  TextEditingController controller;
  FocusNode focusNode;
  String hintText;
  IconData prefixIcon;
  IconData suffixIcon;
  TextInputType inputType;
  bool isPwd;
  MyTextWidget({this.controller,this.focusNode,this.hintText,this.prefixIcon,this.suffixIcon=Icons.cancel,this.inputType=TextInputType.text,this.isPwd=false});
  // 清空X按钮事件
  onCancel() {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.clear());
  }
  @override
  Widget build(BuildContext context) {
    return Container(
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(ScreenAdapter.size(20)),
//        border: Border.all(color:Colors.grey[200] ),
//
//      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: inputType,
        obscureText: isPwd,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: ScreenAdapter.size(28)),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey,
          ),
          suffixIcon:(controller.text ?? null).isEmpty ?
          Text(""):
          IconButton(
            icon: Icon(
              suffixIcon,
              color: Colors.grey,
            ),
            onPressed: onCancel
          )
        ),
      ),
    );
  }

}
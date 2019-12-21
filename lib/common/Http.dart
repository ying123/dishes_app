import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';

Dio _dio = Dio(BaseOptions(
    connectTimeout: 5000,
    // baseUrl: "https://www.zlp.ltd/",
    baseUrl: "http://192.168.1.3:8080/",
    contentType: ContentType.parse("application/json;charset=utf-8")));
    
//Dio get请求方法的封装
Future get(url) async {
  try {
    Response response = await _dio.get(url);
    if (response.statusCode==200) {
      return response.data;
    }else{
      throw Exception("服务器异常");
    }
  } catch (e) {
    print("err:::$e");
  }
}
//Dio post请求方法的封装
Future post(url,{formData}) async {
  try {
    Response response = await _dio.post(url,data: formData);
    if (response.statusCode==200) {
      return response.data;
    }else{
      throw Exception("服务器异常");
    }
  } catch (e) {
    print("err:::$e");
  }
}

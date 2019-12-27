
import 'dart:developer';
import 'package:dio/dio.dart';
import 'dart:async';

import '../routers/Application.dart';

class HttpUtil {
  static HttpUtil _instance;
  Dio _dio;
  BaseOptions _options;

  static HttpUtil getInstance() {
    if (null == _instance) _instance = HttpUtil();
    return _instance;
  }

  HttpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    _options = new BaseOptions(
        //请求地址
         baseUrl: "https://www.zlp.ltd/",
        //baseUrl: "http://192.168.1.3:8080/",
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: 10000,
        //响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: 5000);
    _dio = Dio(_options);
    //添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      options.headers = {"token": Application.token};
      options.contentType = Headers.jsonContentType;
      return options; //continue
    }, onResponse: (Response response) {
      return response; // continue
    }, onError: (DioError e) {
      return e; //continue
    }));
  }

  Future get(url) async {
    Response response;
    try {
      response = await _dio.get(url);
    } on DioError catch (e) {
      _formatError(e);
    }
    return response.data;
  }

  Future post(url, {data}) async {
    Response response;
    try {
      response = await _dio.post(url, data: data);
    } on DioError catch (e) {
      _formatError(e);
    }
    return response.data;
  }

  Future fileUpload(url, filePath,fileName,onSendProgress) async {
    FormData formData =
        FormData.fromMap({"file": await MultipartFile.fromFile(filePath,filename: fileName),"type":"head"});
    Response res = await _dio.post(
      url,
      data: formData,
      onSendProgress: onSendProgress,
    );
    return res.data;
  }

  /*
   * error统一处理
   */
  void _formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      log("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      log("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      log("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      log("响应异常");
    } else if (e.type == DioErrorType.CANCEL) {
      log("请求取消");
    } else {
      log("服务器故障");
    }
  }
}

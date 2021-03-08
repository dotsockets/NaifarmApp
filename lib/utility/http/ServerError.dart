
import 'package:dio/dio.dart' hide Headers;
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';

class ServerError{

  static  ApiResult  DioErrorExpction(DioError error) {
    String message = "";

    switch (error.type) {
      case DioErrorType.CANCEL:
        message = "Request was cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        message = "Connection timeout";
        break;
      case DioErrorType.DEFAULT:
        message = "Connection failed due to internet connection";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        message = "Receive timeout in connection";
        break;
      case DioErrorType.RESPONSE:
        if(error.response.statusCode==406 || error.response.statusCode==400){
          return ApiResult(http_call_back: ThrowIfNoSuccess.fromJson(error.response.data));
        }else{
          message = "Received invalid status code: ${error.response.statusCode}";
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        message = "Receive timeout in send request";
        break;
    }
    if(error.response!=null){
      return ApiResult(http_call_back: ThrowIfNoSuccess(code: error.response.statusCode,message: message));

    }else{
      return ApiResult(http_call_back: ThrowIfNoSuccess(code: 000,message: message));
    }


  }

}

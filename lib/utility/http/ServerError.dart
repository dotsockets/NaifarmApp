
import 'package:dio/dio.dart' hide Headers;
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';

class ServerError{

  static  ApiResult  DioErrorExpction(DioError error) {
    String message = "Please check your internet. And do the list again";

    switch (error.type) {
      case DioErrorType.CANCEL:
        message = "Request was cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        message = "Connection timeout";
        break;
      case DioErrorType.DEFAULT:
        message = "Could not connect to server, please try again.";
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

      return ApiResult(http_call_back: ThrowIfNoSuccess(status: error.response.statusCode,message: message));

    }else{

      return ApiResult(http_call_back: ThrowIfNoSuccess(status: 000,message: message));
    }


  }

}

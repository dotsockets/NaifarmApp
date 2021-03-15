import 'package:dio/dio.dart' hide Headers;
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ServerError {
  static ApiResult dioErrorExpction(DioError error) {
    String message = LocaleKeys.server_error_again.tr();

    switch (error.type) {
      case DioErrorType.CANCEL:
        message = LocaleKeys.server_error_cancel.tr();
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        message = LocaleKeys.server_error_timeout_connect.tr();
        break;
      case DioErrorType.DEFAULT:
        message = LocaleKeys.server_error_default.tr();
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        message = LocaleKeys.server_error_timeout_receive.tr();
        break;
      case DioErrorType.RESPONSE:
        if (error.response.statusCode == 406 ||
            error.response.statusCode == 400) {
          return ApiResult(
              httpCallBack: ThrowIfNoSuccess.fromJson(error.response.data));
        } else {
          message =
              "${LocaleKeys.server_error_status.tr()}: ${error.response.statusCode}";
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        message = LocaleKeys.server_error_timeout_send.tr();
        break;
    }
    if (error.response != null) {
      return ApiResult(
          httpCallBack: ThrowIfNoSuccess(
              status: error.response.statusCode, message: message));
    } else {
      return ApiResult(
          httpCallBack: ThrowIfNoSuccess(status: 000, message: message));
    }
  }
}

import 'ThrowIfNoSuccess.dart';

class ApiResult {
  Object respone;
  ThrowIfNoSuccess httpCallBack;

  ApiResult({this.respone, this.httpCallBack});
}


import 'ThrowIfNoSuccess.dart';

class ApiResult{
  Object respone;
  ThrowIfNoSuccess http_call_back;

  ApiResult({this.respone,this.http_call_back});
}
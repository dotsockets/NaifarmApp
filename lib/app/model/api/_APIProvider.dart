

part of 'APIProvider.dart';



class _APIProvider implements APIProvider {
  _APIProvider(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;
  String baseUrl;

  @override
  Future<List<Task>> getTasks() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/tasks',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Task.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<Fb_Profile> getProFileFacebook(String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "fields":"name,first_name,last_name,email",
      "access_token":access_token
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<dynamic>('/me',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: "https://graph.facebook.com/v2.12"),
        data: _data);
    var value = Fb_Profile.fromJson(jsonDecode(_result.data));

    return value;
  }


  @override
  Future<LoginRespone> CustomersLogin(LoginRequest loginRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "username":loginRequest.username,
      "phone":loginRequest.phone,
      "password":loginRequest.password
    };
    final _result = await _dio.request<dynamic>('/customers/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
  //  throwIfNoSuccess(_result);
    print("esvfcresv ${json.decode(_result.data.toString())}");
    var value = LoginRespone.fromJson(json.decode(_result.data.toString()));
    return value;
  }

  void throwIfNoSuccess(Response response) {
    if(response.statusCode < 200 || response.statusCode > 299) {
      throw new HttpException(response);
    }
  }



}
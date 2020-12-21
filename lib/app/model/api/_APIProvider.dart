

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
    print("cccza007 ${_result.data}");
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

    try {
    final _result = await _dio.request<dynamic>('/customers/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = LoginRespone.fromJson(_result.data);
    return LoginRespone(email: value.email,token: value.token,name: value.name,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return LoginRespone(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }


  }


  @override
  Future<OTPRespone> OtpRequest(String numbephone) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone":numbephone,
    };

    try {
      final _result = await _dio.request<dynamic>('/otp/request',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      var value = OTPRespone.fromJson(_result.data);
      return OTPRespone(phone: value.phone,refCode: value.refCode,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return OTPRespone(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }


  }

  @override
  Future<OtpVerifyRespone> OtpVerify(String phone, String code, String ref) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone":phone,
      "code":code,
      "ref":ref
    };

    try {
      final _result = await _dio.request<dynamic>('/otp/verify',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return OtpVerifyRespone(success: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return OtpVerifyRespone(success: false,http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }
  }

  @override
  Future<RegisterRespone> CustomersRegister(RegisterRequest registerRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "name":registerRequest.name,
      "email":registerRequest.email,
      "password":registerRequest.password,
      "phone":registerRequest.phone,
      "agree":registerRequest.agree
    };

    try {
      final _result = await _dio.request<dynamic>('/customers/register',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      var value = RegisterRespone.fromJson(_result.data);
      return RegisterRespone(id: value.id,name: value.name,niceName: value.niceName,email: value.email,
          phone: value.phone,sex: value.sex,dob: value.dob,description: value.description,shop: value.shop,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return RegisterRespone(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }


  }



}
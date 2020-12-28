

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
  Future<ResponeObject> CustomersLogin(LoginRequest loginRequest) async {
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
    return ResponeObject(respone: LoginRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }


  }


  @override
  Future<ResponeObject> OtpRequest(String numbephone) async {
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
      return ResponeObject(respone: OTPRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      if(e.response.statusCode==416 || e.response.statusCode==400){
        return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
      }else{
        return ResponeObject(http_call_back: ThrowIfNoSuccess(result: Result(error: Error(status: e.response.statusCode,message: "${e.response.statusCode} An error occurred at Server"))));
      }

    }


  }

  @override
  Future<ResponeObject> OtpVerify(String phone, String code, String ref) async {
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
      return ResponeObject(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(respone: true,http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }
  }

  @override
  Future<ResponeObject> CustomersRegister(RegisterRequest registerRequest) async {
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
      return ResponeObject(respone: RegisterRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }


  }

  @override
  Future<ResponeObject> ForgotPasswordRequest(String email) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/customers/forgot-password/${email}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ResponeObject(respone: ForgotRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      if(e.response.statusCode==416 || e.response.statusCode==400){
        return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
      }else{
        return ResponeObject(http_call_back: ThrowIfNoSuccess(result: Result(error: Error(status: e.response.statusCode,message: "${e.response.statusCode} An error occurred at Server"))));
      }

    }
  }

  @override
  Future<ResponeObject> ResetPasswordRequest(String email, String password,String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "email":email,
      "password":password
    };

    try {
      final _result = await _dio.request<dynamic>('/customers/reset-password/${token}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ResponeObject(respone: RegisterRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      if(e.response.statusCode==416 || e.response.statusCode==400){
        return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
      }else{
        return ResponeObject(http_call_back: ThrowIfNoSuccess(result: Result(error: Error(status: e.response.statusCode,message: "${e.response.statusCode} An error occurred at Server"))));
      }

    }
  }

  @override
  Future<ResponeObject> getCustomerInfo(String access_token)async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/customers/info',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ResponeObject(respone: CustomerInfoRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      if(e.response.statusCode==416 || e.response.statusCode==400){
        return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
      }else{
        return ResponeObject(http_call_back: ThrowIfNoSuccess(result: Result(error: Error(status: e.response.statusCode,message: "${e.response.statusCode} An error occurred at Server"))));
      }

    }
  }

  @override
  Future<ResponeObject> ModifyProfile(CustomerInfoRespone data, String access_token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/customers/modify-profile',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ResponeObject(respone: CustomerInfoRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      if(e.response.statusCode==416 || e.response.statusCode==400){
        return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
      }else{
        return ResponeObject(http_call_back: ThrowIfNoSuccess(result: Result(error: Error(status: e.response.statusCode,message: "${e.response.statusCode} An error occurred at Server"))));
      }

    }
  }

  @override
  Future<ResponeObject> ModifyPassword(ModifyPasswordrequest data, String access_token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/customers/modify-password',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ResponeObject(respone: CustomerInfoRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      if(e.response.statusCode==416 || e.response.statusCode==400){
        return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
      }else{
        return ResponeObject(http_call_back: ThrowIfNoSuccess(result: Result(error: Error(status: e.response.statusCode,message: "${e.response.statusCode} An error occurred at Server"))));
      }

    }
  }

  @override
  Future<ResponeObject> VerifyPassword(String password, String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "password": password
    };

    try {
      final _result = await _dio.request<dynamic>('/customers/verify-password',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ResponeObject(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(respone: false,http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }
  }

  @override
  Future<ResponeObject> AddressesList(String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ResponeObject(respone: AddressesListRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }
  }

  @override
  Future<ResponeObject> StatesProvice(String countries) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/countries/1/states',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ResponeObject(respone: StatesRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }
  }

  @override
  Future<ResponeObject> StatesCity(String countries,String statesId) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/countries/${countries}/states/${statesId}/cities',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ResponeObject(respone: StatesRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }
  }

  @override
  Future<ResponeObject> zipCode(String countries,String statesId,String cityId) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/countries/${countries}/states/$statesId/cities/${cityId}/zipCode',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ResponeObject(respone: zipCodeRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ResponeObject(http_call_back: ThrowIfNoSuccess.fromJson(e.response.data));
    }
  }


}
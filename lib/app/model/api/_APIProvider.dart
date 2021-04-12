part of 'APIProvider.dart';

class _APIProvider implements APIProvider {
  _APIProvider(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;
  String baseUrl;

  @override
  Future<ApiResult> getProFileFacebook(
      BuildContext context, String accessToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "fields": "name,first_name,last_name,email,photos",
      "access_token": accessToken
    };
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/me',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: "https://graph.facebook.com/v2.12"),
          data: _data);
      //  var value = Fb_Profile.fromJson(jsonDecode(_result.data));
      return ApiResult(
          respone: FbProfile.fromJson(jsonDecode(_result.data)),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      // FbError item = FbError.fromJson(jsonDecode(e.response.data));
      return ApiResult(
          httpCallBack: ThrowIfNoSuccess(
              status: e.response.statusCode,
              message:
                  FbError.fromJson(jsonDecode(e.response.data)).error.message));
    }
  }

  @override
  Future<ApiResult> customersLogin(
      BuildContext context, LoginRequest loginRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "username": loginRequest.username,
      "phone": loginRequest.phone,
      "password": loginRequest.password
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/login',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: LoginRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> customersLoginSocial(
      BuildContext context, LoginRequest loginRequest, String provider) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "email": loginRequest.email,
      "accessToken": loginRequest.accessToken,
      "name": loginRequest.name
    };

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/login-social/$provider',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: LoginRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> otpRequest(BuildContext context, String numbephone) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone": numbephone,
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/otp/request',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: OTPRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> otpVerify(
      BuildContext context, String phone, String code, String ref) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"phone": phone, "code": code, "ref": ref};

    try {
      final _result = await _dio.request<dynamic>('/v1/otp/verify',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> customersRegister(
      BuildContext context, RegisterRequest registerRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "name": registerRequest.name,
      "email": registerRequest.email,
      "password": registerRequest.password,
      "phone": registerRequest.phone,
      "agree": registerRequest.agree
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/register',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: RegisterRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> forgotPasswordRequest(BuildContext context,
      {String phone, String code, String ref, String password}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone": phone,
      "code": code,
      "ref": ref,
      "password": password
    };

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/forgot-password-phone',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      // ForgotRespone
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> resetPasswordRequest(
      BuildContext context, String email, String password, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"email": email, "password": password};

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/reset-password/$token',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: RegisterRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCustomerInfo(
      BuildContext context, String accessToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/info',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": accessToken,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CustomerInfoRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> modifyProfile(BuildContext context,
      CustomerInfoRespone data, String accessToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result =
          await _dio.request<dynamic>('/v1/customers/modify-profile',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": accessToken,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: data);
      return ApiResult(
          respone: CustomerInfoRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> modifyPassword(BuildContext context,
      ModifyPasswordrequest data, String accessToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result =
          await _dio.request<dynamic>('/v1/customers/modify-password',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": accessToken,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: data);
      return ApiResult(
          respone: CustomerInfoRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> firstPassword(BuildContext context,
      ModifyPasswordrequest data, String accessToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result =
      await _dio.request<dynamic>('/v1/customers/first-password',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": accessToken,
                'Accept-Language':
                EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(
          respone: CustomerInfoRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> verifyPassword(
      BuildContext context, String password, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"password": password};

    try {
      final _result =
          await _dio.request<dynamic>('/v1/customers/verify-password',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'POST',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);

      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addressesList(BuildContext context, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: AddressesListRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> statesProvice(
      BuildContext context, String countries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/countries/1/states',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: StatesRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> statesCity(
      BuildContext context, String countries, String statesId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/countries/$countries/states/$statesId/cities',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: StatesRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> zipCode(BuildContext context, String countries,
      String statesId, String cityId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/countries/$countries/states/$statesId/cities/$cityId/zipCode',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ZipCodeRespone.fromJson(_result.data[0]),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> createAddress(BuildContext context,
      AddressCreaterequest addressCreaterequest, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: addressCreaterequest);

      return ApiResult(
          respone: AddressesData.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteAddress(
      BuildContext context, String id, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses/$id',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateAddress(
      BuildContext context, AddressCreaterequest data, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses/${data.id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);

      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSliderImage(
    BuildContext context,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/sliders',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: SliderRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductPopular(
      BuildContext context, String page, int limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/popular?limit=$limit&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProductRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoryGroup(
    BuildContext context,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/category-group',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CategoryGroupRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoriesFeatured(
    BuildContext context,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/categories/featured',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CategoryGroupRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductTrending(
      BuildContext context, String page, int limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/trending?limit=$limit&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProductRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getShopProduct(BuildContext context,
      {int shopId, String page, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/shop/$shopId/products?limit=$limit&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProductRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSearch(BuildContext context,
      {String page, String query, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/search/products?q=$query&limit=$limit&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: SearchRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> createMyShop(BuildContext context,
      {String name, String slug, String description, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "name": name,
      "slug": slug,
      "description": description
    };

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/myshop?token=$token',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(
          respone: MyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getMyShopInfo(
      BuildContext context, String accessToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": accessToken,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: MyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> myShopUpdate(BuildContext context,
      {MyShopRequest data, String accessToken}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": accessToken,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(
          respone: MyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> myShopActive(BuildContext context,
      {int data, String accessToken}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"active": data};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": accessToken,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: MyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> farmMarket(
    BuildContext context,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/shop/slug/farm-market',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: MyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> moreProduct(BuildContext context,
      {String page, int limit, String link}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/$link?limit=$limit&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProductRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> flashsale(BuildContext context,
      {String page, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/flashsale?limit=$limit&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: FlashsaleRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> uploadImage(BuildContext context,
      {File imageFile,
      String imageableType,
      int imageableId,
      String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/image?imageableType=$imageableType&imageableId=$imageableId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: formData);
      return ApiResult(
          respone: ImageUploadRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> productsById(BuildContext context, {int id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/products/$id',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProducItemRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> shopById(BuildContext context, {int id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/shop/$id',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: MyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> categoryGroupId(BuildContext context,
      {String page, int limit, int groupId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/trending?limit=$limit&page=$page&categoryGroupId=$groupId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProductRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> categorySubgroup(BuildContext context,
      {int groupId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/category-subgroup/$groupId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CategoryGroupRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getBanners(BuildContext context, {String group}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{"group": group};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/banners',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: BannersRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getPaymentList(BuildContext context,
      {String shopIds}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/payments?shopIds=${shopIds}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: PaymentRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getPaymentMyShop(BuildContext context,
      {String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/payment',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: PaymenMyshopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addPaymentMyShop(BuildContext context,
      {int paymentMethodId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"paymentMethodId": paymentMethodId};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/payment',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deletePaymentMyShop(BuildContext context,
      {int paymentMethodId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/payment/$paymentMethodId',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'DELETE',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCarriersList(
    BuildContext context,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/carriers',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CarriersRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getShippingMyShop(BuildContext context,
      {String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shipping',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ShppingMyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteShoppingMyShop(BuildContext context,
      {int ratesId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/shipping/$ratesId',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'DELETE',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shipping',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> editShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, int rateID, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shipping/$rateID',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductMyShop(BuildContext context,
      {String page, int limit, String token, String filter}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products?limit=$limit&page=$page&filter=$filter',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProductMyShopListRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/products',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(
          respone: ProductMyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getWishlistsByProduct(BuildContext context,
      {int productID, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/wishlists/product/$productID',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'GET',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: DataWishlists.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteWishlists(BuildContext context,
      {int wishId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/wishlists/$wishId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addWishlists(BuildContext context,
      {int inventoryId, int productId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "inventoryId": inventoryId,
      "productId": productId
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/wishlists',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: DataWishlists.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getMyWishlists(BuildContext context, {String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/wishlists',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: WishlistsRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCustomerCount(BuildContext context,
      {String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/customers/count',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CustomerCountRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoriesAll(
    BuildContext context,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/all-categories',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CategoriesAllRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategories(
    BuildContext context,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/categories',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CategoriesRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addCartlists(BuildContext context,
      {CartRequest cartRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _data = <String, dynamic>{
    // "inventoryId":inventoryId,
    // "productId":productId
    // };
    try {
      final _result = await _dio.request<dynamic>('/v1/cart',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: cartRequest);
      return ApiResult(
          respone: CartResponse.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductIDMyShop(BuildContext context,
      {int productId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/products/$productId',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'GET',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: ProductMyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, int productId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/products/$productId',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: shopRequest);
      return ApiResult(
          respone: ProductMyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCartlists(BuildContext context, {String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/cart',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: CartResponse.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteProductMyShop(BuildContext context,
      {int productId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/products/$productId',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'DELETE',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteCart(BuildContext context,
      {int cartid, int inventoryid, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "cartId": cartid,
      "inventoryId": inventoryid
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/cart',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateCart(
      BuildContext context, CartRequest data, int cartId, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/cart/$cartId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);

      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateProductInventories(BuildContext context,
      {InventoriesRequest inventoriesRequest,
      int productId,
      int inventoriesId,
      String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/$productId/inventories/$inventoriesId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: inventoriesRequest);
      return ApiResult(
          respone: ProductMyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteImageProduct(BuildContext context,
      {String imageableId,
      String imageableType,
      String path,
      String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "imageableId": imageableId,
      "imageableType": imageableType,
      "path": path,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/image',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getOrder(BuildContext context,
      {String orderType,
      int page,
      int limit,
      String statusId,
      String token,
      String sort}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/$orderType?limit=$limit&page=$page&sort=$sort&orderStatusIds=$statusId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: OrderRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getOrderById(BuildContext context,
      {int id, String orderType, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/$orderType/$id',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: OrderData.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductTypeShop(BuildContext context,
      {String type, int shopId, String page, int limit, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/$type?shopId=$shopId&limit=$limit&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ProductRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getNotificationByGroup(BuildContext context,
      {String group,
      int page,
      String sort = "notification.createdAt:desc",
      int limit,
      String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "group": group,
      "page": page,
      "limit": limit,
      "sort": sort,
    };
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/notifications',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: NotiRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> createOrder(BuildContext context,
      {OrderRequest orderRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/order',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: orderRequest);
      return ApiResult(
          respone: OrderData.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getShippings(BuildContext context, {int shopId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/shop/$shopId/shippings',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: ShippingsRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> markAsReadNotifications(BuildContext context,
      {String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      // "inventoryId":inventoryId,
      // "productId":productId
    };
    try {
      final _result =
          await _dio.request<dynamic>('/v1/notifications/markAsRead',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'POST',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSearchProduct(BuildContext context,
      {String page, String query, int shopId, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/search/products?q=$query&limit=$limit&page=$page&shopId=$shopId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: SearchRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getMyShopAttribute(
      BuildContext context, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/attributes',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: MyShopAttributeRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addMyShopAttribute(BuildContext context,
      {String name, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "name": name,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/attributes',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: MyShopAttributeRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteMyShopAttribute(BuildContext context,
      {int id, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/attributes/$id',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getAttributeDetail(
      BuildContext context, int id, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/attributes/$id/values',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'GET',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: MyShopAttributeRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateAttribute(
      BuildContext context, String name, int id, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{
      "name": name,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/attributes/$id',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(
          respone: MyShopAttributeRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addAttributeDetail(BuildContext context,
      {String value, String color, int id, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"value": value, "color": color};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/attributes/$id/values',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'POST',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: MyShopAttributeRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateAttributeDetail(BuildContext context,
      {String value, String color, int id, int vid, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{"value": value, "color": color};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/attributes/$id/values/$vid',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: data);
      return ApiResult(
          respone: MyShopAttributeRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteAttributeDetail(BuildContext context,
      {int id, String token, int vid}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/attributes/$id/values/$vid',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'DELETE',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);

      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoryByShop(BuildContext context,
      {int categoryId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/shop/$categoryId/category',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'GET',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: CategoryGroupRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getInformationRules(
      BuildContext context, String slug) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/page?slug=$slug',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: InformationRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> requestChangEmail(BuildContext context,
      {String email, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"email": email};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/customers/request-change-email',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'POST',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateinventories(BuildContext context,
      {int productsId,
      int inventoriesId,
      int shippingWeight,
      String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{"shippingWeight": shippingWeight};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/$productsId/inventories/$inventoriesId',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(
          respone: ProductMyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> markPaid(BuildContext context,
      {int orderId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{"orderId": orderId};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/order/$orderId/mark-paid',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: data);
      return ApiResult(
          respone: OrderRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> checkPhone(BuildContext context, {String phone}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone": phone,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/customers/check-phone',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addTracking(BuildContext context,
      {String trackingId, String token, int orderId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "trackingId": trackingId,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/order/$orderId/fulfill',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> goodsReceived(BuildContext context,
      {String token, int orderId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/order/$orderId/goods-received',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: OrderData.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> orderCancel(BuildContext context,
      {String token, int orderId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/order/$orderId/cancel',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: OrderData.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> checkEmail(BuildContext context, {String email}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "email": email,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/customers/check-email',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSearchShop(
      {BuildContext context,
      String page,
      String query,
      int limit,
      int shopId,
      String filter,
      String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/search/products?limit=$limit&page=$page&shopId=$shopId&filter=$filter&q=$query&sort=product.createdAt',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: SearchRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> activeProduct(BuildContext context,
      {int ative, int productId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{"active": ative};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/myshop/products/$productId',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: ProductMyShopRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> requestPayment(BuildContext context,
      {int orderId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result =
          await _dio.request<dynamic>('/v1/order/$orderId/request-payment',
              queryParameters: queryParameters,
              options: RequestOptions(
                  method: 'PATCH',
                  headers: <String, dynamic>{
                    "token": token,
                    'Accept-Language':
                        EasyLocalization.of(context).locale.languageCode
                  },
                  extra: _extra,
                  baseUrl: baseUrl),
              data: _data);
      return ApiResult(
          respone: true,
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSystem(BuildContext context) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/system',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':
                    EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(
          respone: SystemRespone.fromJson(_result.data),
          httpCallBack: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.dioErrorExpction(e);
    }
  }
}

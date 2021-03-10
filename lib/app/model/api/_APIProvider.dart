

part of 'APIProvider.dart';



class _APIProvider implements APIProvider {
  _APIProvider(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;
  String baseUrl;


  @override
  Future<ApiResult> getProFileFacebook(BuildContext context,String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "fields": "name,first_name,last_name,email,photos",
      "access_token": access_token
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
    return ApiResult(respone: Fb_Profile.fromJson(jsonDecode(_result.data)),
        http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CustomersLogin(BuildContext context,LoginRequest loginRequest) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: LoginRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> CustomersLoginSocial(BuildContext context,LoginRequest loginRequest,String provider) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "email": loginRequest.email,
      "accessToken": loginRequest.accessToken,
      "name": loginRequest.name
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/login-social/${provider}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: LoginRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> OtpRequest(BuildContext context,String numbephone) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: OTPRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> OtpVerify(BuildContext context,String phone, String code, String ref) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone": phone,
      "code": code,
      "ref": ref
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/otp/verify',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CustomersRegister(BuildContext context,RegisterRequest registerRequest) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: RegisterRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ForgotPasswordRequest(BuildContext context,
      { String phone, String code, String ref, String password}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      // ForgotRespone
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ResetPasswordRequest(BuildContext context,String email, String password,
      String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "email": email,
      "password": password
    };

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/reset-password/${token}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: RegisterRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCustomerInfo(BuildContext context,String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/info',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": access_token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CustomerInfoRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ModifyProfile(BuildContext context,CustomerInfoRespone data,
      String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/modify-profile',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": access_token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: CustomerInfoRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ModifyPassword(BuildContext context,ModifyPasswordrequest data,
      String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/modify-password',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": access_token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: CustomerInfoRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> VerifyPassword(BuildContext context,String password, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "password": password
    };

    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/verify-password',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode

              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddressesList(BuildContext context,String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: AddressesListRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> StatesProvice(BuildContext context,String countries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/countries/1/states',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: StatesRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> StatesCity(BuildContext context,String countries, String statesId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/countries/${countries}/states/${statesId}/cities',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: StatesRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> zipCode(BuildContext context,String countries, String statesId,
      String cityId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/countries/${countries}/states/$statesId/cities/${cityId}/zipCode',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: zipCodeRespone.fromJson(_result.data[0]),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CreateAddress(BuildContext context,AddressCreaterequest addressCreaterequest,
      String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};


    try {
      final _result = await _dio.request<dynamic>('/v1/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: addressCreaterequest);

      return ApiResult(respone: AddressesData.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DeleteAddress(BuildContext context,String id, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> UpdateAddress(BuildContext context,AddressCreaterequest data,
      String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses/${data.id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);

      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> getSliderImage(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/sliders',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: SliderRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductPopular(BuildContext context,String page, int limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/popular?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoryGroup(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/category-group',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CategoryGroupRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoriesFeatured(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/categories/featured',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CategoryGroupRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductTrending(BuildContext context,String page, int limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/trending?limit=${limit}&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getShopProduct(BuildContext context,{int ShopId, String page, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/shop/${ShopId}/products?limit=${limit}&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSearch(BuildContext context,{String page, String query, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/search/products?q=$query&limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: SearchRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CreateMyShop(BuildContext context,
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
          '/v1/customers/myshop?token=${token}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: MyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getMyShopInfo(BuildContext context,String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": access_token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> MyShopUpdate(BuildContext context,
      {MyShopRequest data, String access_token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": access_token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> FarmMarket(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/shop/slug/farm-market',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> MoreProduct(BuildContext context,{String page, int limit, String link}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/${link}?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> Flashsale(BuildContext context,{String page, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/flashsale?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: FlashsaleRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> UploadImage(BuildContext context,
      {File imageFile, String imageableType, int imageableId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    String fileName = imageFile.path
        .split('/')
        .last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/image?imageableType=${imageableType}&imageableId=${imageableId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: formData);
      return ApiResult(respone: ImageUploadRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ProductsById(BuildContext context,{int id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/products/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProducItemRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ShopById(BuildContext context,{int id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/shop/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> categoryGroupId(BuildContext context,
      {String page, int limit, int GroupId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/trending?limit=${limit}&page=${page}&categoryGroupId=${GroupId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CategorySubgroup(BuildContext context,{int GroupId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/category-subgroup/${GroupId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CategoryGroupRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetBanners(BuildContext context,{String group}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "group": group
    };
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/banners',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: BannersRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetPaymentList(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/payments',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: PaymentRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetPaymentMyShop(BuildContext context,{String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: PaymenMyshopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddPaymentMyShop(BuildContext context,
      {int paymentMethodId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "paymentMethodId": paymentMethodId
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/payment',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DELETEPaymentMyShop(BuildContext context,
      {int paymentMethodId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/payment/${paymentMethodId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetCarriersList(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/carriers',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CarriersRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetShippingMyShop(BuildContext context,{String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ShppingMyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DELETEShoppingMyShop(BuildContext context,{int ratesId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/shipping/${ratesId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shipping',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> EditShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, int rateID, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/shipping/${rateID}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetProductMyShop(BuildContext context,
      {String page, int limit, String token, String filter}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products?limit=${limit}&page=${page}&filter=${filter}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductMyShopListRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/products',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(respone: ProductMyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetWishlistsByProduct(BuildContext context,{int productID, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "productId": productID
    };
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/wishlists',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: WishlistsRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DELETEWishlists(BuildContext context,{int WishId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/wishlists/${WishId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddWishlists(BuildContext context,
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: DataWishlists.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetMyWishlists(BuildContext context,{String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: WishlistsRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetCustomerCount(BuildContext context,{String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CustomerCountRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetCategoriesAll(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/all-categories',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CategoriesAllRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetCategories(BuildContext context,) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/categories',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CategoriesRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddCartlists(BuildContext context,
      {CartRequest cartRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      // "inventoryId":inventoryId,
      // "productId":productId
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/cart',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: cartRequest);
      return ApiResult(respone: CartResponse.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> GetProductIDMyShop(BuildContext context,{int productId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/${productId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductMyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> UpdateProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, int productId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/${productId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(respone: ProductMyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetCartlists(BuildContext context,{String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CartResponse.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> DELETEProductMyShop(BuildContext context,{int ProductId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/${ProductId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> DELETECart(BuildContext context,
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> UpdateCart(BuildContext context,CartRequest data, int cartId,
      String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/cart/${cartId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);

      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> UpdateProductInventories(BuildContext context,
      {InventoriesRequest inventoriesRequest, int productId, int inventoriesId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/${productId}/inventories/${inventoriesId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: inventoriesRequest);
      return ApiResult(respone: ProductMyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DeleteImageProduct(BuildContext context,
      {String imageableId, String imageableType, String path, String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetOrder(BuildContext context,
      {String orderType, int page, int limit, String statusId, String token,String sort}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/${orderType}?limit=${limit}&page=${page}&sort=${sort}&orderStatusIds=${statusId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: OrderRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetOrderById(BuildContext context,{int id,String orderType, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/${orderType}/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: OrderData.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
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
          '/v1/products/types/${type}?shopId=${shopId}&limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetNotificationByGroup(BuildContext context,
      {String group, int page, String sort = "notification.createdAt:desc", int limit, String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: NotiRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CreateOrder(BuildContext context,
      {OrderRequest orderRequest, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/order',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: orderRequest);
      return ApiResult(respone: OrderData.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetShippings(BuildContext context,{int shopId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/shop/${shopId}/shippings',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ShippingsRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> MarkAsReadNotifications(BuildContext context,{String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      // "inventoryId":inventoryId,
      // "productId":productId
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/notifications/markAsRead',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
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
          '/v1/search/products?q=$query&limit=${limit}&page=${page}&shopId=${shopId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: SearchRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getMyShopAttribute(BuildContext context,String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/attributes',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopAttributeRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addMyShopAttribute(BuildContext context,{String name, String token}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopAttributeRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteMyShopAttribute(BuildContext context,{int id, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/attributes/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getAttributeDetail(BuildContext context,int id, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/attributes/${id}/values',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopAttributeRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateAttribute(BuildContext context,String name, int id, String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{
      "name": name,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/attributes/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: MyShopAttributeRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> addAttributeDetail(BuildContext context,
      {String value, String color, int id, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "value": value,
      "color": color
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/attributes/${id}/values',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopAttributeRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateAttributeDetail(BuildContext context,{String value, String color, int id, int vid, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{
      "value": value,
      "color": color
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/attributes/${id}/values/${vid}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: MyShopAttributeRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> deleteAttributeDetail(BuildContext context,
      {int id, String token, int vid}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/attributes/${id}/values/${vid}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetCategoryByShop(BuildContext context,{int CategoryId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/shop/${CategoryId}/category',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CategoryGroupRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getInformationRules(BuildContext context,String slug) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/v1/page?slug=${slug}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: InformationRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> requestChangEmail(BuildContext context,{String email, String token}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "email":email
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/customers/request-change-email',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> updateinventories(BuildContext context,{int productsId, int inventoriesId,int shippingWeight, String token}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{
      "shippingWeight": shippingWeight
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/${productsId}/inventories/${inventoriesId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: ProductMyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> MarkPaid(BuildContext context,{int orderId, String token}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final data = <String, dynamic>{
      "orderId": orderId
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/order/${orderId}/mark-paid',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: OrderRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> checkPhone(BuildContext context,{String phone}) async {
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddTracking(BuildContext context,{String trackingId, String token,int OrderId}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "trackingId": trackingId,
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/order/${OrderId}/fulfill',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GoodsReceived(BuildContext context,{String token, int OrderId}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/order/${OrderId}/goods-received',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: OrderData.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> OrderCancel(BuildContext context,{String token, int OrderId}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/order/${OrderId}/cancel',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: OrderData.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CheckEmail(BuildContext context,{String email}) async{
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
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSearchShop({BuildContext context,String page, String query, int limit, int shopId, String filter,String token}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/search/products?limit=${limit}&page=${page}&shopId=${shopId}&filter=${filter}&q=${query}&sort=product.createdAt',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: SearchRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AtiveProduct(BuildContext context, {int ative, int productId, String token}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "active":ative
    };
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/myshop/products/${productId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token,
                'Accept-Language':EasyLocalization.of(context).locale.languageCode
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductMyShopRespone.fromJson(_result.data),
          http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    } on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


}


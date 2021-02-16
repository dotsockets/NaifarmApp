

part of 'APIProvider.dart';



class _APIProvider implements APIProvider {
  _APIProvider(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;
  String baseUrl;


  @override
  Future<Fb_Profile> getProFileFacebook(String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      "fields": "name,first_name,last_name,email",
      "access_token": access_token
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
  Future<ApiResult> CustomersLogin(LoginRequest loginRequest) async {
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> OtpRequest(String numbephone) async {
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> OtpVerify(String phone, String code, String ref) async {
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> CustomersRegister(RegisterRequest registerRequest) async {
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> ForgotPasswordRequest(
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> ResetPasswordRequest(String email, String password,
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> getCustomerInfo(String access_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/info',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": access_token
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
  Future<ApiResult> ModifyProfile(CustomerInfoRespone data,
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
                "token": access_token
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
  Future<ApiResult> ModifyPassword(ModifyPasswordrequest data,
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
                "token": access_token
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
  Future<ApiResult> VerifyPassword(String password, String token) async {
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
                "token": token
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
  Future<ApiResult> AddressesList(String token) async {
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
                "token": token
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
  Future<ApiResult> StatesProvice(String countries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/countries/1/states',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> StatesCity(String countries, String statesId) async {
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> zipCode(String countries, String statesId,
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> CreateAddress(AddressCreaterequest addressCreaterequest,
      String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};


    try {
      final _result = await _dio.request<dynamic>('/v1/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> DeleteAddress(String id, String token) async {
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
                "token": token
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
  Future<ApiResult> UpdateAddress(AddressCreaterequest data,
      String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses/${data.id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> getSliderImage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/sliders',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> getProductPopular(String page, int limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/popular?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> getCategoryGroup() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/category-group',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> getCategoriesFeatured() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/categories/featured',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> getProductTrending(String page, int limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/products/types/trending?limit=${limit}&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> getShopProduct({int ShopId, String page, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/shop/${ShopId}/products?limit=${limit}&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> getSearch({String page, String query, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/search/products?q=$query&limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> CreateMyShop(
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> getMyShopInfo(String access_token) async {
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
                "token": access_token
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
  Future<ApiResult> MyShopUpdate(
      {MyShopRequest data, String access_token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": access_token
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
  Future<ApiResult> FarmMarket() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {
      final _result = await _dio.request<dynamic>('/v1/shop/slug/farm-market',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> MoreProduct({String page, int limit, String link}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/${link}?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> Flashsale({String page, int limit}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/flashsale?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> UploadImage(
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
                "token": token
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
  Future<ApiResult> ProductsById({int id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/products/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> ShopById({int id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/shop/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> categoryGroupId(
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> CategorySubgroup({int GroupId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/category-subgroup/${GroupId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> GetBanners({String group}) async {
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> GetPaymentList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/payments',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> GetPaymentMyShop({String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/payment',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> AddPaymentMyShop(
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
                "token": token
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
  Future<ApiResult> DELETEPaymentMyShop(
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
                "token": token
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
  Future<ApiResult> GetCarriersList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/carriers',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> GetShippingMyShop({String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shipping',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> DELETEShoppingMyShop({int ratesId, String token}) async {
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
                "token": token
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
  Future<ApiResult> AddShoppingMyShop(
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
                "token": token
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
  Future<ApiResult> EditShoppingMyShop(
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
                "token": token
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
  Future<ApiResult> GetProductMyShop(
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
                "token": token
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
  Future<ApiResult> AddProductMyShop(
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
                "token": token
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
  Future<ApiResult> GetWishlistsByProduct({int productID, String token}) async {
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
                "token": token
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
  Future<ApiResult> DELETEWishlists({int WishId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/wishlists/${WishId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> AddWishlists(
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
                "token": token
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
  Future<ApiResult> GetMyWishlists({String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/wishlists',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> GetCustomerCount({String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/customers/count',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> GetCategoriesAll() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/all-categories',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> GetCategories() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/categories',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> AddCartlists(
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
                "token": token
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
  Future<ApiResult> GetProductIDMyShop({int productId, String token}) async {
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
                "token": token
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
  Future<ApiResult> UpdateProductMyShop(
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
                "token": token
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
  Future<ApiResult> GetCartlists({String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/cart',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> DELETEProductMyShop({int ProductId, String token}) async {
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
                "token": token
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
  Future<ApiResult> DELETECart(
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
                "token": token
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
  Future<ApiResult> UpdateCart(CartRequest data, int cartId,
      String token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/cart/${cartId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> UpdateProductInventories(
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
                "token": token
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
  Future<ApiResult> DeleteImageProduct(
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
                "token": token
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
  Future<ApiResult> GetOrder(
      {String orderType, int page, int limit, String statusId, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/${orderType}?limit=${limit}&page=${page}&sort=orders.createdAt:desc&orderStatusIds=${statusId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> GetOrderById({int id,String orderType, String token}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/${orderType}/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> getProductTypeShop(
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
                "token": token
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
  Future<ApiResult> GetNotificationByGroup(
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
                "token": token
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
  Future<ApiResult> CreateOrder(
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
                "token": token
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
  Future<ApiResult> GetShippings({int shopId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>(
          '/v1/shop/${shopId}/shippings',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
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
  Future<ApiResult> MarkAsReadNotifications({String token}) async {
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
                "token": token
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
  Future<ApiResult> getSearchMyshop(
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
              headers: <String, dynamic>{},
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
  Future<ApiResult> getMyShopAttribute(String token) async {
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
                "token": token
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
  Future<ApiResult> addMyShopAttribute({String name, String token}) async {
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
                "token": token
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
  Future<ApiResult> deleteMyShopAttribute({int id, String token}) async {
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
                "token": token
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
  Future<ApiResult> getAttributeDetail(int id, String token) async {
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
                "token": token
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
  Future<ApiResult> updateAttribute(String name, int id, String token) async {
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
                "token": token
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
  Future<ApiResult> addAttributeDetail(
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
                "token": token
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
  Future<ApiResult> updateAttributeDetail({String value, String color, int id, int vid, String token}) async {
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
                "token": token
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
  Future<ApiResult> deleteAttributeDetail(
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
                "token": token
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
  Future<ApiResult> GetCategoryByShop({int CategoryId, String token}) async {
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
                "token": token
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
  Future<ApiResult> getInformationRules(String slug) async {
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
  Future<ApiResult> requestChangEmail({String email, String token}) async{
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
                "token": token
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
  Future<ApiResult> updateinventories({int productsId, int inventoriesId,int shippingWeight, String token}) async{
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
                "token": token
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
  Future<ApiResult> MarkPaid({int orderId, String token}) async{
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
                "token": token
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
  Future<ApiResult> checkPhone({String phone}) async {
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
  Future<ApiResult> AddTracking({String trackingId, String token,int OrderId}) async{
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
                "token": token
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
  Future<ApiResult> GoodsReceived({String token, int OrderId}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/order/${OrderId}/goods-received',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token
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
  Future<ApiResult> OrderCancel({String token, int OrderId}) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {
      final _result = await _dio.request<dynamic>('/v1/order/${OrderId}/cancel',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token": token
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
}


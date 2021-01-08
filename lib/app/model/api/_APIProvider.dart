

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
  Future<ApiResult> CustomersLogin(LoginRequest loginRequest) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "username":loginRequest.username,
      "phone":loginRequest.phone,
      "password":loginRequest.password
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
    return ApiResult(respone: LoginRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }


  @override
  Future<ApiResult> OtpRequest(String numbephone) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone":numbephone,
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
      return ApiResult(respone: OTPRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }


  }

  @override
  Future<ApiResult> OtpVerify(String phone, String code, String ref) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "phone":phone,
      "code":code,
      "ref":ref
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
      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CustomersRegister(RegisterRequest registerRequest) async {
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
      final _result = await _dio.request<dynamic>('/v1/customers/register',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: RegisterRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }


  }

  @override
  Future<ApiResult> ForgotPasswordRequest(String email) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/forgot-password/${email}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: ForgotRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }
  }

  @override
  Future<ApiResult> ResetPasswordRequest(String email, String password,String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "email":email,
      "password":password
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/reset-password/${token}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: RegisterRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }
  }

  @override
  Future<ApiResult> getCustomerInfo(String access_token)async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/info',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CustomerInfoRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }
  }

  @override
  Future<ApiResult> ModifyProfile(CustomerInfoRespone data, String access_token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/modify-profile',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: CustomerInfoRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }
  }

  @override
  Future<ApiResult> ModifyPassword(ModifyPasswordrequest data, String access_token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/modify-password',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: CustomerInfoRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }
  }

  @override
  Future<ApiResult> VerifyPassword(String password, String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "password": password
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/verify-password',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddressesList(String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/v1/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: AddressesListRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> StatesProvice(String countries) async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: StatesRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> StatesCity(String countries,String statesId) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/v1/countries/${countries}/states/${statesId}/cities',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: StatesRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> zipCode(String countries,String statesId,String cityId) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/v1/countries/${countries}/states/$statesId/cities/${cityId}/zipCode',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: zipCodeRespone.fromJson(_result.data[0]),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CreateAddress(AddressCreaterequest addressCreaterequest,String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};


    try {
      final _result = await _dio.request<dynamic>('/v1/addresses',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: addressCreaterequest);

      return ApiResult(respone: AddressesData.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DeleteAddress(String id, String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses/${id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> UpdateAddress(AddressCreaterequest data, String token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/addresses/${data.id}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);

      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

 


  @override
  Future<ApiResult> getSliderImage() async{
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: SliderRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductPopular(String page,int limit) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/products/types/popular?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoryGroup() async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: CategoryGroupRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getCategoriesFeatured() async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: CategoryGroupRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProductTrending(String page,int limit) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/products/types/trending?limit=${limit}&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getProduct(String page,int limit) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/products/types/products?limit=${limit}&page=$page',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> getSearch({String page, String query,int limit}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/search/products?q=$query&limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: SearchRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CreateMyShop({String name, String slug, String description, String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "name":name,
      "slug":slug,
      "description":description
    };

    try {
      final _result = await _dio.request<dynamic>('/v1/customers/myshop?token=${token}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);

      return ApiResult(respone: MyShopRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }
  }

  @override
  Future<ApiResult> getMyShopInfo(String access_token) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
    };
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> MyShopUpdate({MyShopRequest data, String access_token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};

    try {
      final _result = await _dio.request<dynamic>('/v1/myshop/shop',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token":access_token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: data);
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);

    }
  }

  @override
  Future<ApiResult> FarmMarket() async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> MoreProduct({String page, int limit, String link}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/${link}?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> Flashsale({String page, int limit}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/flashsale?limit=${limit}&page=${page}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: FlashsaleRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> UploadImage({File imageFile,String imageableType, int imageableId, String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    String fileName = imageFile.path.split('/').last;
    FormData _data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });
    FormData  formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path,filename: fileName),
    });
    try {

      final _result = await _dio.request<dynamic>('/v1/image?imageableType=${imageableType}&imageableId=${imageableId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: formData);
      return ApiResult(respone: ImageUploadRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ProductsById({int id}) async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: ProducItemRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> ShopById({int id}) async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: MyShopRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> categoryGroupId({String page, int limit, int GroupId}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/products/types/products?limit=${limit}&page=${page}&categoryGroupId=${GroupId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ProductRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> CategorySubgroup({int GroupId}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/category-subgroup/${GroupId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: CategoryGroupRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetBanners({String group}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{
      "group":group
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
      return ApiResult(respone: BannersRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetPaymentList() async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: PaymentRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetPaymentMyShop({String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/payment',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: PaymenMyshopRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddPaymentMyShop({int paymentMethodId, String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "paymentMethodId":paymentMethodId
    };
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/payment',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DELETEPaymentMyShop({int paymentMethodId, String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/payment/${paymentMethodId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetCarriersList() async {
    const _extra = <String, dynamic>{ };
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
      return ApiResult(respone: CarriersRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> GetShippingMyShop({String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/shipping',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'GET',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: ShppingMyShopRespone.fromJson(_result.data),http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> DELETEShoppingMyShop({int ratesId, String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/shipping/${ratesId}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'DELETE',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> AddShoppingMyShop({ShppingMyShopRequest shopRequest, String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/shipping',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'POST',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }

  @override
  Future<ApiResult> EditShoppingMyShop({ShppingMyShopRequest shopRequest,int rateID, String token}) async {
    const _extra = <String, dynamic>{ };
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    try {

      final _result = await _dio.request<dynamic>('/v1/myshop/shipping/${rateID}',
          queryParameters: queryParameters,
          options: RequestOptions(
              method: 'PATCH',
              headers: <String, dynamic>{
                "token":token
              },
              extra: _extra,
              baseUrl: baseUrl),
          data: shopRequest);
      return ApiResult(respone: true,http_call_back: ThrowIfNoSuccess(status: _result.statusCode));
    }on DioError catch (e) {
      return ServerError.DioErrorExpction(e);
    }
  }




}
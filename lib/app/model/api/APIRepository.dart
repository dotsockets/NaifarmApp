

import 'package:dio/dio.dart';
import 'package:naifarm/app/model/api/APIProvider.dart';
import 'package:naifarm/app/model/db/DBNaiFarmRepository.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/http/HttpException.dart';
import 'package:naifarm/utility/log/DioLogger.dart';
import 'package:rxdart/rxdart.dart';


class APIRepository{
  static const String TAG = 'AppAPIRepository';

  APIProvider _apiProvider;
  DBBookingRepository _dbAppStoreRepository;

  APIRepository(this._apiProvider, this._dbAppStoreRepository);

  Future<List<Task>> getTag(){
   // final api = APIProvider(_dio, baseUrl: "http://mockserver");
    // final options = buildCacheOptions(Duration(days: 10));

    // api.getTags(options: options).then((it) {
    //   print(it.length);
    // });
    // APIProvider(ApiClient().Dio_Data()).getTasks().then((response){
    //   return _apiProvider.getTasks();
    // }).catchError((err){
    //   print(err);
    // });

    return _apiProvider.getTasks();
  }

  Future<Fb_Profile> getFBProfile({String access_token}){
   // throwIfNoSuccess(response);
    return _apiProvider.getProFileFacebook(access_token);
  }

  Future<LoginRespone> CustomersLogin({LoginRequest loginRequest}){
    // throwIfNoSuccess(response);
    return _apiProvider.CustomersLogin(loginRequest);
  }

//  Observable<List<AppContent>> getTop100FreeApp(){
//    return Observable.fromFuture(_apiProvider.getTopFreeApp(TOP_100))
//        .flatMap(_convertFromEntry)
//        .flatMap((List<AppContent> list){
//      return Observable.fromFuture(_loadAndSaveTopFreeApp(list, ''));
//    });
//  }
//



}
import 'package:dio/dio.dart';
import 'package:naifarm/app/model/api/APIProvider.dart';
import 'package:naifarm/app/model/api/APIRepository.dart';
import 'package:naifarm/app/model/db/AppDatabaseMigrationListener.dart';
import 'package:naifarm/app/model/db/DBNaiFarmRepository.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/db/DatabaseHelper.dart';
import 'package:naifarm/utility/framework/Application.dart';
import 'package:naifarm/utility/log/DioLogger.dart';
import 'package:naifarm/utility/log/Log.dart';
import 'package:logging/logging.dart';

class AppNaiFarmApplication implements Application {
  Dio _dio;
  DatabaseHelper _db;
  DBBookingRepository dbAppStoreRepository;
  APIRepository appStoreAPIRepository;

  @override
  Future<void> onCreate() async {
    _initLog();
    await _initDB();
    _initDioLog();
    _initDBRepository();
    _initAPIRepository();
  }

  @override
  Future<void> onTerminate() async {
    await _db.close();
  }

  Future<void> _initDB() async {
    AppDatabaseMigrationListener migrationListener =
        AppDatabaseMigrationListener();
    DatabaseConfig databaseConfig = DatabaseConfig(
        Env.value.dbVersion, Env.value.dbName, migrationListener);
    _db = DatabaseHelper(databaseConfig);
    Log.info('DB name : ' + Env.value.dbName);
    await _db.open();
  }

  void _initDBRepository() {
    dbAppStoreRepository = DBBookingRepository(_db.database);
  }

  void _initAPIRepository() {
    var options = BaseOptions(
      baseUrl: Env.value.baseUrl,
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
    _dio.options = options;
    APIProvider apiProvider = APIProvider(_dio, baseUrl: Env.value.baseUrl);
    appStoreAPIRepository = APIRepository(apiProvider, dbAppStoreRepository);
  }

  void _initLog() {
    Log.init();
    switch (Env.value.environmentType) {
      case EnvType.DEVELOPMENT:
        Log.setLevel(Level.ALL);
        break;
      case EnvType.STAGING:
        {
          Log.setLevel(Level.ALL);
          break;
        }
      case EnvType.PRODUCTION:
        {
          Log.setLevel(Level.ALL);
          break;
        }
    }
  }

  void _initDioLog() {
    _dio = Dio();
    if (EnvType.PRODUCTION == Env.value.environmentType ||
        EnvType.STAGING == Env.value.environmentType) {

      _dio.interceptors.add(InterceptorsWrapper(
          onRequest:(options, handler){
            DioLogger.onSend(APIRepository.TAG, options);
            return handler.next(options);
          },
          onResponse:(response,handler) {
            DioLogger.onSuccess(APIRepository.TAG, response);
            return handler.next(response);
          },
          onError: (DioError e, handler) {
            DioLogger.onError(APIRepository.TAG, e);
            return  handler.next(e);
          }
      ));




    }
  }
}



import 'package:dio/dio.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/http/HttpException.dart';
import 'package:naifarm/utility/log/DioLogger.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:retrofit/retrofit.dart';

part '_APIProvider.dart';

abstract class APIProvider{
  factory APIProvider(Dio dio, {String baseUrl}) = _APIProvider;

  @GET("/tasks")
  Future<List<Task>> getTasks();

}

// @JsonSerializable()
// class Task {
//   String id;
//   String name;
//   String avatar;
//   String createdAt;
//
//   Task({this.id, this.name, this.avatar, this.createdAt});
//
//
//   factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
//   Map<String, dynamic> toJson() => _$TaskToJson(this);
// }

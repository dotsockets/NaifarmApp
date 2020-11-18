

import 'package:dio/dio.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:convert';
part '_APIProvider.dart';

abstract class APIProvider{
  factory APIProvider(Dio dio, {String baseUrl}) = _APIProvider;

  @GET("/tasks")
  Future<List<Task>> getTasks();

  @GET("/tasks/{id}")
  Future<Fb_Profile> getProFileFacebook(@Query("access_token") String access_token);

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

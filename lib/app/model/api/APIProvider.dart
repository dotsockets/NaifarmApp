

import 'package:dio/dio.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/OtpVerifyRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/utility/http/HttpException.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:convert';
part '_APIProvider.dart';

abstract class APIProvider{
  factory APIProvider(Dio dio, {String baseUrl}) = _APIProvider;

  @GET("/tasks")
  Future<List<Task>> getTasks();

  @GET("/tasks/{id}")
  Future<Fb_Profile> getProFileFacebook(@Query("access_token") String access_token);

  @POST("/customers/login")
  Future<LoginRespone> CustomersLogin(@Body() LoginRequest loginRequest);

  @POST("/customers/register")
  Future<RegisterRespone> CustomersRegister(@Body() RegisterRequest registerRequest);

  @POST("/otp/request")
  @FormUrlEncoded()
  Future<OTPRespone> OtpRequest(@Field() String numbephone);

  @POST("/otp/verify")
  @FormUrlEncoded()
  Future<OtpVerifyRespone> OtpVerify(@Field() String phone,@Field() String code,@Field() String ref);

  @POST("/customers/forgot-password")
  Future<ForgotRespone> ForgotPasswordRequest(@Part() String email);

  @POST("/customers/reset-password")
  @FormUrlEncoded()
  Future<RegisterRespone> ResetPasswordRequest(@Field() String email,@Field() String password,@Field() String token);

  @GET("/customers/info")
  Future<CustomerInfoRespone> getCustomerInfo(String access_token);


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

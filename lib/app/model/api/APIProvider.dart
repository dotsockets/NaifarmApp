

import 'package:dio/dio.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/ResponeObject.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/utility/http/HttpException.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
part '_APIProvider.dart';

abstract class APIProvider{
  factory APIProvider(Dio dio, {String baseUrl}) = _APIProvider;

  @GET("/tasks")
  Future<List<Task>> getTasks();

  @GET("/tasks/{id}")
  Future<Fb_Profile> getProFileFacebook(@Query("access_token") String access_token);

  @POST("/customers/login")
  Future<ResponeObject> CustomersLogin(@Body() LoginRequest loginRequest);

  @POST("/customers/register")
  Future<ResponeObject> CustomersRegister(@Body() RegisterRequest registerRequest);

  @POST("/otp/request")
  @FormUrlEncoded()
  Future<ResponeObject> OtpRequest(@Field() String numbephone);

  @POST("/otp/verify")
  @FormUrlEncoded()
  Future<ResponeObject> OtpVerify(@Field() String phone,@Field() String code,@Field() String ref);

  @POST("/customers/forgot-password")
  Future<ResponeObject> ForgotPasswordRequest(@Part() String email);

  @POST("/customers/reset-password")
  @FormUrlEncoded()
  Future<ResponeObject> ResetPasswordRequest(@Field() String email,@Field() String password,@Field() String token);

  @GET("/customers/info")
  Future<ResponeObject> getCustomerInfo(String access_token);

  @PATCH("/customers/modify-profile")
  Future<ResponeObject> ModifyProfile(@Body() CustomerInfoRespone data,String access_token);

  @PATCH("/customers/modify-password")
  Future<ResponeObject> ModifyPassword(@Body() ModifyPasswordrequest data,String access_token);

  @POST("/customers/verify-password")
  @FormUrlEncoded()
  Future<ResponeObject> VerifyPassword(@Field() String password,String token);

  @GET("/addresses")
  Future<ResponeObject> AddressesList(String token);

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

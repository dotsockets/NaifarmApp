
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';

class EditProfileVIew extends StatelessWidget {
  List<String> datalist = ["ชาย","หญิง"];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: GestureDetector(
                      child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,size: 30
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  expandedHeight: 220,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: ThemeColor.primaryColor(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text(LocaleKeys.my_profile_title.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.bold),),
                          SizedBox(height: 20,),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            child: CachedNetworkImage(
                              width: 80,
                              height: 80,
                              placeholder: (context, url) => Container(
                                color: Colors.white,
                                child: Lottie.asset(Env.value.loadingAnimaion,
                                    height: 30),
                              ),
                              fit: BoxFit.cover,
                              imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_rDu4Nc6GLkHxx1h3h7NV-skFgSoaV7Ltgw&usqp=CAU",
                              errorWidget: (context, url, error) => Container(
                                  height: 30,
                                  child: Icon(
                                    Icons.error,
                                    size: 30,
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.only(right: 15,left: 15,bottom: 5,top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: ThemeColor.ColorSale()
                            ),
                            child: Text(LocaleKeys.edit_img_btn.tr(),
                                style: FunctionHelper.FontTheme(
                                    color: Colors.white,
                                    fontSize:  SizeUtil.detailSmallFontSize(),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    Container(
                      height: 700,
                      child: Column(
                        children: [
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "บ้านจำปีแดง",
                            title: LocaleKeys.my_profile_name.tr(),
                            onClick: ()=> AppRoute.Setting_EditProfile_Name(context),
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "เป็นร้านจำหน่าย...",
                            title: LocaleKeys.my_profile_about_me.tr(),
                            onClick: ()=>AppRoute.Setting_EditProdile_Bio(context),
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "ชาย",
                            title: LocaleKeys.my_profile_gender.tr(),
                            onClick: () {
                              Platform.isAndroid?FunctionHelper.DropDownAndroid(context,datalist,onTap:(int index){}):FunctionHelper.DropDownIOS(context,datalist,onTap:(int index){});
                            },
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "09 กรกฎาคม 2563",
                            title: LocaleKeys.my_profile_birthday.tr(),
                            onClick: () {
                              Platform.isAndroid?FunctionHelper.selectDate(context,OnDateTime: (DateTime s){}):FunctionHelper.showPickerDate(context,datalist,onTap:(DateTime index){Navigator.pop(context);});
                            },
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "xxxxxx0987",
                            title: LocaleKeys.my_profile_phone.tr(),
                            onClick: () {
                              AppRoute.EditPhoneStep1(context);
                            },
                          ),
                          SizedBox(height: 10,),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "puwee@gmail.com",
                            title: LocaleKeys.my_profile_email.tr(),
                            onClick: () {
                              AppRoute.EditEmail_Step1(context);
                            },
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "********",
                            title: LocaleKeys.my_profile_change_password.tr(),
                            onClick: () {
                              AppRoute.EditpasswordStep1(context);
                            },
                          ),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      height: 0.5,
      color: Colors.black.withOpacity(0.4),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate:DateTime.now().add(Duration(days: 30)),
    );

  }

}

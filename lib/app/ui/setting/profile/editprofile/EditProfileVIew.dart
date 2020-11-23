
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';

class EditProfileVIew extends StatelessWidget {
  List<String> datalist = ["ชาย","หญิง","อื่นๆ"];
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
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: ThemeColor.primaryColor(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text("ข้อมูลส่วนตัว",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.bold),),
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
                            child: Text("แก้ไขรูป",
                                style: GoogleFonts.sarabun(
                                    color: Colors.white,
                                    fontSize:  ScreenUtil().setSp(35),
                                    fontWeight: FontWeight.bold)),
                          )
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
                            title: "ชื่อ",
                            onClick: ()=> AppRoute.Setting_EditProfile_Name(context),
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "เป็นร้านจำหน่าย...",
                            title: "แนะนำตัวเอง",
                            onClick: ()=>AppRoute.Setting_EditProdile_Bio(context),
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "ชาย",
                            title: "เพศ",
                            onClick: () {
                              Platform.isAndroid?FunctionHelper.DropDownAndroid(context,datalist,onTap:(int index){}):FunctionHelper.DropDownIOS(context,datalist,onTap:(int index){});
                            },
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "09 กรกฎาคม 2563",
                            title: "วันเกิด",
                            onClick: () {
                              Platform.isAndroid?FunctionHelper.selectDate(context,OnDateTime: (DateTime s){}):FunctionHelper.showPickerDate(context,datalist,onTap:(DateTime index){Navigator.pop(context);});
                            },
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "xxxxxx0987",
                            title: "เบอร์โทรศัพท์",
                            onClick: () {
                              AppRoute.EditPhoneStep1(context);
                            },
                          ),
                          SizedBox(height: 10,),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "puwee@gmail.com",
                            title: "อีเมล",
                            onClick: () {
                              AppRoute.EditEmail_Step1(context);
                            },
                          ),
                          _buildLine(),
                          ListMenuItem(
                            opacityMessage: 0.5,
                            icon: '',
                            Message: "********",
                            title: "เปลี่ยนรหัสผ่าน",
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

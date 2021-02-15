
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class TransferPayMent extends StatefulWidget {
  final OrderData orderData;

  const TransferPayMent({Key key, this.orderData}) : super(key: key);
  @override
  _TransferPayMentState createState() => _TransferPayMentState();
}

class _TransferPayMentState extends State<TransferPayMent> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File fileImage;

  bool onDialog = false;
  OrdersBloc bloc;

  init(BuildContext context) {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.AlertDialogShop(context,
            title: "Error", message: event);
      //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        onDialog = true;
        FunctionHelper.SuccessDialog(context,message: "Successfully uploaded",onClick: (){
          if(onDialog){
            Navigator.pop(context,true);
          }

        });

      });
    }
    // Usermanager().getUser().then((value) => context.read<OrderBloc>().loadOrder(statusId: 1, limit: 20, page: 1, token: value.token));
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: AppToobar(
            title: "Payment information",
            header_type: Header_Type.barNormal,
            isEnable_Search: false,
            icon: '',onClick: (){
            AppRoute.PoppageCount(context: context,countpage: 1);
          },
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                InfoMessage(title: "1",message: "หากท่านต้องการชำระเงินผ่านตู้ ATM หรือหน้าเคาท์เตอร์ธนาคาร ท่านสามารถเลือก ATM Bill Payment ใน Naifarm ได้เช่นกัน ซึ่งวิธีนี้ท่านไม่จำเป็นต้องอัพโหลดเอกสารการชำระเงิน และสามารถรอการยืนยันการชำระเงินได้รวดเร็วกว่า หากท่านยืนยันที่จะเลือกช่องทางนี้ ท่านสามารถชำระเงินผ่าน intenet/mobile banking มายังบัญชีธนาคารของ Naifarm"),
                CardBank(index: 0),
                CardBank1(index: 1),
                InfoMessage(title: "2",message: "เก็บหลักฐานการโอนเงินและอัพโหลดภายใน 14-01-2021",padding_bottom: false),
                InfoMessage(title: "3",message: "เพื่อความรวดเร็วในการยืนยันการชำระเงินของท่าน ขอแนะนำให้ท่านอัพโหลดหลักฐานการชำระเงินที่ท่านได้รับจาก mobile banking application หรือ internet banking แทนการอัพโหลดหลักฐานประเภทอื่น ซึ่งอาจทำให้ตรวจสอบการชำระเงินล่าช้า"),
                ButtonItem()
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget CardBank({int index}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1),bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: index!=0?1:0)),
      ),
      width: MediaQuery.of(context).size.width,

      child: Row(
        children: [
          SizedBox(width: 5.0.w,height: 5.0.w,),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 1.0.h,bottom: 1.0.h,left: 3.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ไทยพานิชย์ (SCB)",
                    style: FunctionHelper.FontTheme(color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.5.h,),
                  Text(
                    "ชื่อบัญชี: บริษัท แอร์เพย์ ประเทศไทย จำกัด",
                    style: FunctionHelper.FontTheme(color: Colors.black.withOpacity(0.5),
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 0.5.h,),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text:  TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: "เลขที่บัญชี : ",
                                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.5))),
                              TextSpan(text: "468 0601 709",style: FunctionHelper.FontTheme(fontSize: (SizeUtil.titleSmallFontSize()).sp,fontWeight: FontWeight.bold,color: ThemeColor.ColorSale())),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          child: Text(
                            "คัดลอก",
                            style: FunctionHelper.FontTheme(color: ThemeColor.secondaryColor(),
                                fontSize: SizeUtil.titleSmallFontSize().sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: (){
                          FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "คัดลอกแล้ว");
                        },
                      ),
                      SizedBox(width: 3.0.w,)
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CardBank1({int index}){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1),bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: index!=0?1:0)),
      ),
      child: Row(
        children: [
          SizedBox(width: 5.0.w,height: 5.0.w,),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 1.0.h,bottom: 1.0.h,left: 3.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "กสิกร",
                    style: FunctionHelper.FontTheme(color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 0.5.h,),
                  Text(
                    "ปิดปรับปรุงชั่วคราว",
                    style: FunctionHelper.FontTheme(color: Colors.black.withOpacity(0.5),
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ButtonItem(){
    return Container(
      padding: EdgeInsets.all(3.0.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1),bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      child: Column(
        children: [
          Container(
            width: 80.0.w,
            height: 5.0.h,
            child: FlatButton(
              color: ThemeColor.secondaryColor(),
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: () {
                captureImage(ImageSource.gallery);
              },
              child: Text(
                widget.orderData.image.length==0?"มีหลักฐานการชำระเงิน อัพโหลดเลย":"อัพเดตหลักฐานการชำระ",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 1.5.h,),
          widget.orderData.image.length==0?Container(
            width: 80.0.w,
            height: 5.0.h,
            child: FlatButton(
              color: ThemeColor.ColorSale(),
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "ไม่มีมีหลักฐานการชำระเงิน และอัพโหลดที่หลัง",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ):SizedBox()
        ],
      ),
    );
  }

  Widget InfoMessage({String title,String message,bool padding_bottom=true}){
    return Container(
      padding: EdgeInsets.only(bottom: padding_bottom?1.0.h:0.0.h,left: 1.0.h,right: 1.0.h,top: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 2.0.w),
            padding: EdgeInsets.all(1.0.h),
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),

            child: Text(
              title,
              style: FunctionHelper.FontTheme(color: Colors.white,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 0.8.h),
              child: Text(
                message,
                style: FunctionHelper.FontTheme(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future captureImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);


      if (pickedFile != null) {
        fileImage = File(pickedFile.path);
        Usermanager().getUser().then((value) => bloc.UploadImage(context: context,imageFile: fileImage,imageableType: "order",imageableId: widget.orderData.id,token: value.token));
      } else {
        print('No image selected.');
      }

  }
}

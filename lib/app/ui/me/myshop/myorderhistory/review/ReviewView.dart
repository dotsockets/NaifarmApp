
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomStarRating.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class ReviewView extends StatefulWidget {
  @override
  _ReviewViewState createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {


  TextEditingController reviewController = TextEditingController();
  bool SelectSwitch = false;
  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: LocaleKeys.btn_review.tr(),
            header_type: Header_Type.barNormal,
            isEnable_Search: false,
            icon: '',
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  _Header(item: ProductViewModel().getHistorySuccess()[0],index: 0,context: context),
                  SizedBox(height: 2.0.w,),
                  _BuildForm(context),
                  SizedBox(height: 2.0.w,),
                  HideNameRate(),
                  _buildBtnSend(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget HideNameRate(){
    return Container(
      padding: EdgeInsets.only(right: 2.0.w,left: 2.0.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.0.w),
              Text("รีวิวโดยไม่เปิดชื่อ",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 1.0.w),
              Text("ชื่อที่จะแสดง: farnmarket@mail.com",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp, color: Colors.black.withOpacity(0.5))),
              SizedBox(height: 20,)
            ],
          ),
          FlutterSwitch(
            width: 14.0.w,
            height: 4.0.h,
            activeColor: Colors.grey.shade200,
            inactiveColor: Colors.grey.shade200,
            toggleColor:
            SelectSwitch ? ThemeColor.primaryColor() : Colors.grey.shade400,
            value: SelectSwitch ? true : false,
            onToggle: (val) {
             setState(() {
               SelectSwitch = !SelectSwitch;
             });
            },
          )
        ],
      ),
    );
  }

  Future<void> loadAssets({int maxImages}) async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImages,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );


    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future captureFile(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: imageSource);


    setState(() {
      if (pickedFile != null) {
       // fileImage = File(pickedFile.path);
        print("dsceed ${ File(pickedFile.path)}");
      //   Usermanager().getUser().then((value) => bloc.UploadImage(context: context,imageFile: fileImage,imageableType: "customer",imageableId: itemInfo.id,token: value.token));
      } else {
        print('No file selected.');
      }
    });
  }

  Widget _Header({ProductModel item,int index,BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 15),
      color: Colors.white,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(LocaleKeys.order_detail_order_num.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
          //     Text("09988203dergd4",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold),),
          //
          //   ],
          // ),
          // SizedBox(height: 10,),
          // Container(
          //   padding: EdgeInsets.only(left: 15,top: 15,bottom: 5,right: 20),
          //   color: Colors.white,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           ClipRRect(
          //             borderRadius: BorderRadius.all(Radius.circular(20)),
          //             child: CachedNetworkImage(
          //               width: 25,
          //               height: 25,
          //               placeholder: (context, url) => Container(
          //                 color: Colors.white,
          //                 child: Lottie.asset('assets/json/loading.json', height: 30),
          //               ),
          //               fit: BoxFit.cover,
          //               imageUrl: item.ProfiletImage,
          //               errorWidget: (context, url, error) => Container(
          //                   height: 30,
          //                   child: Icon(
          //                     Icons.error,
          //                     size: 30,
          //                   )),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Text(item.shopName,
          //               style:
          //               FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold))
          //         ],
          //       ),
          //
          //     ],
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag:"history_${index}",
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: CachedNetworkImage(
                    width: 22.0.w,
                    height: 22.0.w,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: Lottie.asset('assets/json/loading.json', height: 30),
                    ),
                    fit: BoxFit.contain,
                    imageUrl: "https://dev2-test.naifarm.com/img/thumb.e4f48571.png",
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.0.w),
                    Text("อโวกาโก้ ภาคเหนือ",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500)),
                    SizedBox(height: 1.0.w),
                    Text("ตัวเลือกสินค้า: ดำ, XL",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp, color: Colors.black.withOpacity(0.5))),
                    SizedBox(height: 20,)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _BuildForm(BuildContext context){
    return Container(
      padding: EdgeInsets.only(bottom: 20,top: 15),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
        child: Column(
          children: [
            Text(LocaleKeys.review_rate.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            CustomStarRating(
                allowHalfRating: false,
                onRated: (v) {},
                starCount: 5,
                rating: 0,
                size: 45.0,
                isReadOnly: false,
                filledIconData: 'assets/images/svg/star_active.svg',
                halfFilledIconData: 'assets/images/svg/star_unactive.svg',
                color: Colors.amber,
                borderColor: Colors.amber,
                spacing: 0.0),
            SizedBox(height: 10,),
            Divider(color: Colors.black.withOpacity(0.5),),
            SizedBox(height: 5,),
            Container(
              child: Row(
                children: [
                  Expanded(child:InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 2.0.w,right: 1.0.w),
                      padding: EdgeInsets.all(2.0.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: ThemeColor.secondaryColor(),width: 1)
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt,color: ThemeColor.secondaryColor(),),
                          Text("เพิ่มรูปภาพ",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500,color: ThemeColor.secondaryColor())),
                        ],
                      ),
                    ),
                    onTap: (){
                      loadAssets(maxImages: 10);
                    },
                  )),
                  Expanded(child:InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 1.0.w,right: 2.0.w),
                      padding: EdgeInsets.all(2.0.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: ThemeColor.secondaryColor(),width: 1)
                      ),
                      child: Column(
                        children: [
                          Icon(FontAwesome.video_camera,color: ThemeColor.secondaryColor(),),
                          Text("เพิ่มวีดีโอ",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500,color: ThemeColor.secondaryColor())),
                        ],
                      ),
                    ),
                    onTap: (){
                      captureFile(ImageSource.gallery);
                    },
                  ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,right: 20,top: 20),
              child: BuildEditText(
                  head: LocaleKeys.btn_review.tr()+" * ",maxLength: 5000,
                  hint: "Tell others why the product is good",maxLine: 5,controller: reviewController,inputType: TextInputType.text),
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _BuildButtonreview(title: "ส่งไวมาก",onClick: ()=>reviewController.text = "ส่งไวมาก" ),
                  SizedBox(width: 10,),
                  _BuildButtonreview(title: "สินค้าดีมาก",onClick: ()=>reviewController.text = "สินค้าดีมาก"),
                  SizedBox(width: 10,),
                  _BuildButtonreview(title: "คุณภาพดี",onClick: ()=>reviewController.text = "คุณภาพดี"),
                ],
              ),
            ),

          ],
        ),
    );
  }

  Widget _BuildButtonreview({String title="",Function() onClick}){
    return FlatButton(
      color: Colors.grey.shade300,
      textColor: Colors.black,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      onPressed: () {
        onClick();
      },
      child: Text(
        title,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBtnSend({Function() onClick}){
    return Container(
      margin: EdgeInsets.only(top: 20,bottom: 20),
      child: FlatButton(
        color: ThemeColor.secondaryColor(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          onClick();
        },
        child: Text(
          LocaleKeys.btn_confirm.tr(),
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

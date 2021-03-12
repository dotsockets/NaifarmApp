


import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ImageUploadRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

import 'Setting_EditProfile_NameView.dart';

class EditProfileVIew extends StatefulWidget {
  @override
  _EditProfileVIewState createState() => _EditProfileVIewState();
}

class _EditProfileVIewState extends State<EditProfileVIew> {
  MemberBloc bloc;
  List<String> datalist = ["ชาย","หญิง"];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CustomerInfoRespone itemInfo = CustomerInfoRespone();
  bool onUpdate = false;
  bool onImageUpdate = false;
  File fileImage;


  void _init(){
    if(null == bloc){
      bloc = MemberBloc(AppProvider.getApplication(context));

      NaiFarmLocalStorage.getCustomer_Info().then((value){
        itemInfo = value.customerInfoRespone;
      });

      // bloc.onLoad.stream.listen((event) {
      //   if(event){
      //     FunctionHelper.showDialogProcess(context);
      //   }else{
      //     Navigator.of(context).pop();
      //   }
      // });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        if(event is ImageUploadRespone){
          Future.delayed(
              const Duration(milliseconds: 1000), () {
            Usermanager().getUser().then((value) =>
                context
                    .read<InfoCustomerBloc>()
                    .loadCustomInfo(context,
                    token: value.token,oneSignal: false));
          });
          setState(() {
            onImageUpdate = true;
            itemInfo.image[0].path = (event as ImageUploadRespone).path;
          });
        }
        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });



    }

  }



  @override
  Widget build(BuildContext context) {


    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
            backgroundColor: Colors.grey.shade200,
            body: BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
              builder: (_, item) {
                if(item is InfoCustomerLoaded){
                  return  _ContentMe(itemInfo: item.profileObjectCombine.customerInfoRespone);
                }else if(item is InfoCustomerLoading){
                  return  _ContentMe(itemInfo: item.profileObjectCombine.customerInfoRespone);
                }else{
                  return  SizedBox();
                }

              },
            )),

      ),
    );
  }

  Widget _ContentMe({CustomerInfoRespone itemInfo}){
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Container(
              margin: EdgeInsets.only(left: 1.5.w),
              child: IconButton(
                icon: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios_rounded,color: Colors.white,),
                onPressed: (){
                  if(onUpdate){
                    Usermanager().getUser().then((value) =>  bloc.ModifyProfile(context: context,data: itemInfo,token: value.token,onload: false));
                  }
                  Navigator.pop(context,onImageUpdate);


                },
              )
          ),
          expandedHeight: 220,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: ThemeColor.primaryColor(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text(LocaleKeys.my_profile_title.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
                  SizedBox(height: 30,),
                  GestureDetector(
                      child: Hero(
                        tag: "image_profile_me",
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          child: fileImage==null?CachedNetworkImage(
                            width: 80,
                            height: 80,
                            placeholder: (context, url) => Container(
                              width: 80,height: 80,
                              color: Colors.white,
                              child: Lottie.asset('assets/json/loading.json',
                                  height: 30),
                            ),
                            fit: BoxFit.cover,
                            imageUrl:itemInfo!=null&&itemInfo.image.length!=0?"${Env.value.baseUrl}/storage/images/${itemInfo.image[0].path}":"",
                            errorWidget: (context, url, error) => Container(
                                color: Colors.grey
                                    .shade300,
                                width: 20.0.w,
                                height: 20.0.w,
                                child: Icon(
                                  Icons.person,
                                  size: 10.0.w,
                                  color: Colors
                                      .white,
                                ))
                          ):Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                color: Colors.white,
                                child: Lottie.asset('assets/json/loading.json',
                                    height: 30),
                              ),
                              Image.file(fileImage,width: 80, height: 80,fit: BoxFit.cover,),

                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        captureImage(ImageSource.gallery);
                      }
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(right: 15,left: 15,bottom: 5,top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: ThemeColor.ColorSale()
                      ),
                      child: Text(LocaleKeys.btn_edit_img.tr(),
                          style: FunctionHelper.FontTheme(
                              color: Colors.white,
                              fontSize:  SizeUtil.detailSmallFontSize(),
                              fontWeight: FontWeight.bold)),
                    ),
                    onTap: (){
                      captureImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Container(
              child: Column(
                children: [

                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    Message: itemInfo.name!=null?itemInfo.name:'',
                    title: LocaleKeys.my_profile_name.tr(),
                    onClick: () async {
                      final result = await AppRoute.Setting_EditProfile_Name(context,itemInfo);
                      if(result!=null){
                        onUpdate = true;
                        setState(()=>itemInfo = (result as CustomerInfoRespone));
                      }
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    Message: itemInfo.description!=null?itemInfo.description.length>20?'${itemInfo.description.substring(0,20)}...':itemInfo.description:'',
                    title: LocaleKeys.my_profile_about_me.tr(),
                    onClick: () async {
                      final result = await AppRoute.Setting_EditProdile_Bio(context,itemInfo);
                      if(result!=null){
                        onUpdate = true;
                        setState(()=>itemInfo = (result as CustomerInfoRespone));
                      }
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    Message: itemInfo.sex!=null?itemInfo.sex:'',
                    title: LocaleKeys.my_profile_gender.tr(),
                    onClick: () {
                      Platform.isAndroid?FunctionHelper.DropDownAndroid(context,datalist,onTap:(int index){
                        onUpdate = true;
                        setState(()=>itemInfo.sex = datalist[index]);
                      }):FunctionHelper.DropDownIOS(context,datalist,onTap:(int index){
                        onUpdate = true;
                        setState(()=>itemInfo.sex = datalist[index]);
                      });
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    Message: itemInfo.dob!=null?itemInfo.dob:'',
                    title: LocaleKeys.my_profile_birthday.tr(),
                    onClick: () {
                      Platform.isAndroid?FunctionHelper.selectDateAndroid(context,DateTime.parse(itemInfo.dob!=null?itemInfo.dob:DateFormat('yyyy-MM-dd').format(DateTime.now())),OnDateTime: (DateTime date){
                        onUpdate = true;
                        if(date!=null)  setState(()=>itemInfo.dob = DateFormat('yyyy-MM-dd').format(date));
                      }):FunctionHelper.showPickerDateIOS(context,DateTime.parse(itemInfo.dob!=null?itemInfo.dob:DateFormat('yyyy-MM-dd').format(DateTime.now())),onTap:(DateTime date){
                        onUpdate = true;
                        if(date!=null) setState(()=>itemInfo.dob = DateFormat('yyyy-MM-dd').format(date));
                      });
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    Message: itemInfo.phone!=null?itemInfo.phone:'',
                    title: LocaleKeys.my_profile_phone.tr(),
                    onClick: () async {
                      final result = await AppRoute.EditPhoneStep1(context,itemInfo);
                      if(result!=null){
                        Usermanager().getUser().then((value) =>  bloc.ModifyProfile(context: context,data: itemInfo,token: value.token,onload: false));
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    Message: itemInfo.email!=null?itemInfo.email:'',
                    title: LocaleKeys.my_profile_email.tr(),
                    onClick: () {
                      AppRoute.EditEmail_Step1(context,itemInfo);
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
    );
  }

  Widget _buildLine() {
    return Container(
      height: 0.1.w,
      color: Colors.black.withOpacity(0.4),
    );
  }


  Future captureImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);


    setState(() {
      if (pickedFile != null) {
        fileImage = File(pickedFile.path);
        Usermanager().getUser().then((value) => bloc.UploadImage(context: context,imageFile: fileImage,imageableType: "customer",imageableId: itemInfo.id,token: value.token));
      } else {
        print('No image selected.');
      }
    });
  }


}

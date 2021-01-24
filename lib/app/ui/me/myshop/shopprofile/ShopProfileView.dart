
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/MyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/ImageUploadRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/EditProviceView.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:sizer/sizer.dart';

import 'EditProviceView.dart';

class ShopProfileView extends StatefulWidget {

  @override
  _ShopprofileState createState() => _ShopprofileState();
}

class _ShopprofileState extends State<ShopProfileView> with RouteAware {
  MemberBloc bloc;
  List<String> datalist = ["ชาย","หญิง"];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MyShopRespone itemInfo = MyShopRespone();
  bool onUpdate = false;
  bool isSelect = false;
  File fileImage;
  bool onImageUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _init(){
    if(null == bloc){
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        // if(event){
        //   FunctionHelper.showDialogProcess(context);
        // }else{
        //   Navigator.of(context).pop();
        // }
      });
      bloc.onError.stream.listen((event) {
       // Navigator.of(context).pop();
        onUpdate  = false;
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        if(event is ImageUploadRespone){
          setState(() {
            onImageUpdate = true;
            itemInfo.image[0].path = (event as ImageUploadRespone).path;
          });
        }else{
          setState(() {
            itemInfo = event;
            isSelect = itemInfo.active==1?true:false;
          });
        }

       if(onUpdate || onImageUpdate){
         Navigator.pop(context,true);
       }
        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });

      Usermanager().getUser().then((value) => bloc.getMyShopInfo(token: value.token));

    }

  }

  void OnSave(){
    if(onUpdate){
      Usermanager().getUser().then((value) =>  bloc.MyShopUpdate(data: MyShopRequest(
          name: itemInfo.name,
          description: itemInfo.description,
          slug: itemInfo.slug,
          legalName: itemInfo.legalName,
          externalUrl: itemInfo.externalUrl,
          stateId: itemInfo.state!=null?itemInfo.state.id:0,
          active: isSelect?1:0
      ),access_token: value.token));
      // Navigator.of(context).pop();
    }else{
      Navigator.pop(context,onImageUpdate);
    }
  }



  @override
  Widget build(BuildContext context) {


    _init();
    return WillPopScope(
      onWillPop: ()async{
        OnSave();
        return true;
      },
      child: Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
          bottom: false,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.grey.shade200,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,size: 4.5.w
                        ),
                        onPressed: (){
                          OnSave();
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
                            Text("แก้ไขร้านค้า",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.bold),),
                            SizedBox(height: 4.0.h,),
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(60)),
                              child: fileImage==null?CachedNetworkImage(
                                width: 20.0.w,
                                height: 20.0.w,
                                placeholder: (context, url) => Container(
                                  width: 20.0.w,
                                  height: 20.0.w,
                                  color: Colors.white,
                                  child: Lottie.asset(Env.value.loadingAnimaion,
                                      height: 30),
                                ),
                                fit: BoxFit.cover,
                                imageUrl:itemInfo!=null?itemInfo.image!=null?"${Env.value.baseUrl}/storage/images/${itemInfo.image.isNotEmpty?itemInfo.image[0].path:''}":'':'',
                                errorWidget: (context, url, error) => Container(
                                    color: Colors.white,
                                    width: 20.0.w,
                                    height: 20.0.w,
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey.shade300,
                                    )),
                              ):Stack(
                                children: [
                                  Container(
                                    width: 20.0.w,
                                    height: 20.0.w,
                                    color: Colors.white,
                                    child: Lottie.asset(Env.value.loadingAnimaion,
                                        height: 30),
                                  ),
                                  Image.file(fileImage,width: 80, height: 80,fit: BoxFit.cover,),

                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              child: Container(
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
                        height: 50.0.h,
                        child: Column(
                          children: [

                            ListMenuItem(
                              opacityMessage: 0.5,
                              icon: '',
                              Message: itemInfo.name!=null?itemInfo.name:'',
                              title: "ชื่อร้านค้า",
                              onClick: () async {
                                final result = await AppRoute.EditNameShop(context,itemInfo: itemInfo);
                                if(result!=null){
                                  onUpdate = true;
                                  setState(()=>itemInfo = result);
                                }
                              },
                            ),
                            _buildLine(),
                            ListMenuItem(
                              opacityMessage: 0.5,
                              icon: '',
                              Message: itemInfo.legalName!=null?itemInfo.legalName.length>20?'${itemInfo.legalName.substring(0,20)}...':itemInfo.legalName:'',
                              title: "ชื่อเป็นทางการ",
                              onClick: () async {
                               final result = await AppRoute.OfficialName(context,itemInfo: itemInfo);
                               if(result!=null){
                                 onUpdate = true;
                                  setState(()=>itemInfo = result);
                               }
                              },
                            ),
                            _buildLine(),
                            ListMenuItem(
                              opacityMessage: 0.5,
                              icon: '',
                              Message: itemInfo.slug!=null?itemInfo.slug:'',
                              title: "Slug ร้านค้า",
                              onClick: () async{
                                final result = await AppRoute.EditSlug(context,itemInfo: itemInfo);
                                if(result!=null){
                                  onUpdate = true;
                                  setState(()=>itemInfo = result);
                                }
                              },
                            ),
                            _buildLine(),
                            ListMenuItem(
                              opacityMessage: 0.5,
                              icon: '',
                              Message: itemInfo.description!=null?itemInfo.description:'',
                              title: "รายละเอียด",
                              onClick: () async {
                                final result = await AppRoute.EditDetail(context,itemInfo: itemInfo);
                                if(result!=null){
                                  onUpdate = true;
                                  setState(()=>itemInfo = result);
                                }
                              },
                            ),
                            _buildLine(),
                            ListMenuItem(
                              opacityMessage: 0.5,
                              icon: '',
                              Message: itemInfo.externalUrl!=null?itemInfo.externalUrl:'',
                              title: "ลิงค์ภายนอก",
                              onClick: () async {
                                final result = await AppRoute.EditExtrlUrl(context,itemInfo: itemInfo);
                                if(result!=null){
                                  onUpdate = true;
                                  setState(()=>itemInfo = result);
                                }
                              },
                            ),
                            _buildLine(),
                            ListMenuItem(
                              opacityMessage: 0.5,
                              icon: '',
                              Message: itemInfo!=null?itemInfo.state!=null?itemInfo.state.name:'':'',
                              title: "จังหวัด",
                              onClick: () async {
                                final result = await AppRoute.EditProvice(context,itemInfo: itemInfo);

                                if(result!=null){
                                  onUpdate = true;
                                  setState(()=>itemInfo = result);
                                }
                              },
                            ),
                            _buildLine(num: 10),
                            ListMenuItem(
                              opacityMessage: 0.5,
                              icon: '',
                              SelectSwitch: isSelect,
                              IsSwitch: (bool select){
                                onUpdate = true;
                                setState(()=> isSelect = select);
                              },
                              title: "สถานะร้านค้า",
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
      ),
    );
  }

  Widget _buildLine({double num=0.5}) {
    return Container(
      height: num,
      color: Colors.grey.shade300,
    );
  }

  Future captureImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);


    setState(() {
      if (pickedFile != null) {
        fileImage = File(pickedFile.path);
        Usermanager().getUser().then((value) => bloc.UploadImage(imageFile: fileImage,imageableType: "shop",imageableId: itemInfo.id,token: value.token));
      } else {
        print('No image selected.');
      }
    });
  }



}

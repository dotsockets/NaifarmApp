import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/Available.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/Banned.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/InActive.dart';
import 'package:naifarm/app/ui/me/myproduct/filter/SoldOut.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class MyProductView extends StatefulWidget {
  final int shopId;
  final int indexTab;

  const MyProductView({Key key, this.shopId,this.indexTab}) : super(key: key);

  @override
  _MyProductViewState createState() => _MyProductViewState();
}

class _MyProductViewState extends State<MyProductView> {
  List<ProductModel> listProducts = ProductViewModel().getMyProducts();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UploadProductBloc bloc;
  int limit = 5;
  int page = 1;
  bool step_page = false;

  init(){

     if(bloc==null){
       bloc=UploadProductBloc(AppProvider.getApplication(context));
     /*  bloc.onSuccess.stream.listen((event)  {
          if(event is bool){
            bloc.ProductMyShopRes.add(bloc.ProductMyShopRes.value);
         }
       });

       bloc.onError.stream.listen((event) {
         FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
         Future.delayed(const Duration(milliseconds: 1000), () {
           Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: page.toString(),limit: 5,token: value.token));
         });
       });
*/
     }
  }


  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: ThemeColor.primaryColor(),
            title:Text(
              LocaleKeys.me_title_my_product.tr(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w600),
          ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.search,size: 7.0.w,color: Colors.white,),
                onPressed: (){
                  AppRoute.SearchMyProductView(context: context,shopID: widget.shopId);},
              ),
              IconButton(
                icon: Icon(FontAwesome.ellipsis_v,size: 7.0.w,color: Colors.white,)
                ,onPressed: (){ ButtonDialog(context,message: ["จัดการแอททริบิวต์"],onClick: (){
                Navigator.of(context).pop();
                AppRoute.Attribute(context: context);
              });},
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  height: 180.0.w,
                  color: Colors.white,
                  child: DefaultTabController(
                    length: 4,
                    initialIndex: widget.indexTab,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 7.0.h,
                            child: Container(
                              child: TabBar(
                                indicatorColor: ThemeColor.ColorSale(),
                                isScrollable: false,
                                tabs: [
                                  _tab(
                                      title: "ขายอยู่",
                                      message:
                                      false),
                                  _tab(
                                      title: "สินค้าหมด",
                                      message:
                                      false),
                                  _tab(title:
                                  "ถูกระงับ",message: false),
                                  _tab(title: "ไม่แสดง",message: false)
                                ],
                              ),
                            ),
                          ),
                          // create widgets for each tab bar here
                          Expanded(
                            child:
                            TabBarView(
                              children: [
                                Available(shopId: widget.shopId,scaffoldKey: _scaffoldKey,),
                               SoldOut(shopId: widget.shopId,scaffoldKey: _scaffoldKey),
                                Banned(shopId: widget.shopId,scaffoldKey: _scaffoldKey),
                                InActive(shopId: widget.shopId,scaffoldKey: _scaffoldKey),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _BuildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildButton() {
    return Container(
     margin: EdgeInsets.all(2.0.w),
        width: 50.0.w,
        height: 5.0.h,
        child: FlatButton(
          color: ThemeColor.secondaryColor(),
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () async {
            // index==0?AppRoute.ProductAddType(context):AppRoute.ImageProduct(context);
            var result = await AppRoute.ImageProduct(context,isactive: IsActive.ReplacemenView);
            if(result){
              Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: "1",limit: 5,token: value.token));
            }
          },
          child: Text(
            LocaleKeys.add_product_btn.tr(),
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
          ),
        )
      );
  }

  Widget _tab({String title, bool message}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: FunctionHelper.FontTheme(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: Colors.black)),
          message
              ? ClipRRect(
            borderRadius: BorderRadius.circular(9.0),
            child: Container(
              alignment: Alignment.center,
              width: 10,
              height: 20,
              color: ThemeColor.ColorSale(),
            ),
          ) : SizedBox()
        ],
      ),
    );
  }
  Widget ButtonDialog(BuildContext context, {Function() onClick,List<String> message}) {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: InkWell(
            onTap: (){
              onClick();
            },
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(message.length, (index) =>  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(message[index],
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,),
                  ))
                )
            ),
          ),
        );
      },
    );
  }

}

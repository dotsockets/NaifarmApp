
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
//'assets/images/svg/cart_top.svg'
class NotiShop extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool btnBack;
  final NotiRespone notiRespone;
  const NotiShop({Key key, this.btnBack=false, this.scaffoldKey, this.notiRespone}) : super(key: key);
  @override
  _NotiShopState createState() => _NotiShopState();
}

class _NotiShopState extends State<NotiShop> with AutomaticKeepAliveClientMixin<NotiShop>{
  NotiBloc bloc;
  init(){
    if(bloc==null){
      bloc = NotiBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        //FunctionHelper.SnackBarShow(scaffoldKey: widget.scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        // Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
      });

      //  bloc.onSuccess.add(widget.notiRespone);

      Usermanager().getUser().then((value) {
        if (value.token != null) {
          NaiFarmLocalStorage.getNowPage().then((page){
            if(page==2){
              bloc.GetNotification(group: "shop",page: 1,limit: 10,sort: "notification.createdAt:desc",token: value.token);
            }
          });

        }
      });


    }



  }
  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      child: StreamBuilder(
        stream: bloc.feedList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var item = (snapshot.data as NotiRespone);
          if(snapshot.hasData && item.data.isNotEmpty){
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(

                  children: item.data
                      .asMap()
                      .map((index, value) {
                    return MapEntry(
                        index,
                        Column(
                          children: [
                            _BuildCardNoti(
                                item: value,context: context,index: index),
                          ],
                        ));
                  })
                      .values
                      .toList(),
                ),
              ),
            );
          }else{
            return Container(
              margin: EdgeInsets.only(bottom: 15.0.h),
              child: Center(
                child:  Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  GestureDetector _BuildCardNoti({NotiData item,BuildContext context,int index}) => GestureDetector(
    onTap: (){
      // if(item.Status_Sell==1)
      //   AppRoute.NotiDetail(context,"notiitem_${index}","notititle_${index}");
      // else
      //   item.Status_Sell!=2?AppRoute.OrderDetail(context,item.Status_Sell):print("press 2");

    },
    child: Dismissible(
      background: Container(
        padding: EdgeInsets.only(right: 5.0.w),
        alignment: Alignment.centerRight,
        color: ThemeColor.ColorSale(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/json/delete.json',
                height: 4.0.h,
                width: 4.0.h,
                repeat: true),
            Text(
              LocaleKeys.cart_del.tr(),
              style: FunctionHelper.FontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      key: Key(
          "${item.id}"),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart ||
            direction == DismissDirection.startToEnd) {
          var item = (bloc.onSuccess.value as NotiRespone);
          item.data.removeAt(index);
          bloc.onSuccess.add(item);
        }


      },
      child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
          ),
          padding: EdgeInsets.only(top: index==0?1.0.h:2.0.h,right: 1.0.w,left: 1.0.w,bottom: 2.0.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: CachedNetworkImage(
                      width: 7.0.w,
                      height: 7.0.w,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child: Lottie.asset(Env.value.loadingAnimaion,  width: 7.0.w,
                            height: 7.0.w),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: "https://www.lnwshop.com/system/application/modules/lnwshopweb/_images/lnwshop_why/shop.png",
                      errorWidget: (context, url, error) => Container(
                          width: 7.0.w,
                          height: 7.0.w,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10,right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ConvertStatusText(type: item.type,meta: item.meta),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
                            SizedBox(height: 0.5.h),
                            Wrap(
                              children: [
                                Text("คุณได้ทำรายการสั่งซื้อสินค้า หมายเลขคำสั่งซื้อ  ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
                               // Text(ConvertStatusSubText(type: item.type,meta: item.meta),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor())),

                              ],
                            )

                          ],
                        ),
                      )),
                  SizedBox(width: 1.0.w,),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black.withOpacity(0.4),
                    size: 4.0.w,
                  )
                ],
              ),
              SizedBox(height: 5,),

            ],
          )
      ),
    ),
  );

  String ConvertStatusText({String type,Meta meta}){
    if(type=="App\\Notifications\\Order\\OrderCreated"){
      return meta.status;
    }else{
      return "แจ้งเตือน คำสั่งซื้อใหม่";
    }
  }

  String ConvertStatusSubText({String type,Meta meta}){
    if(type=="App\\Notifications\\Order\\OrderCreated"){
      return "รายการ ${meta.order}";
    }else{
      return "แจ้งเตือน คำสั่งซื้อใหม่";
    }
  }

  @override
  bool get wantKeepAlive => true;
}



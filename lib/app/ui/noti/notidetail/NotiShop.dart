
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ExpandedSection.dart';
import 'package:sizer/sizer.dart';
import 'package:vibration/vibration.dart';
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
  int limit = 10;
  int page = 1;
  bool step_page = false;
  ScrollController _scrollController = ScrollController();
  bool warning = true;
  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;


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

    }

    bloc.refreshProducts(group: "shop",limit: limit,page: page);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
          _scrollController.position.pixels <= 200) {
        if (step_page) {
          step_page = false;
          page++;
          bloc.refreshProducts(group: "shop",limit: limit,page: page);
        }
      }
    });

  }




  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      child: StreamBuilder(
        stream: bloc.feedList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var item = (snapshot.data as NotiRespone);
          if(snapshot.hasData){
            step_page = item.data.length != item.total?true:false;
            if(item.data.isNotEmpty){
              return Platform.isAndroid?AndroidRefreshIndicator(item: item):IOSRefreshIndicator(item: item);
            }else{
              return Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 15.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/boxorder.json',
                          height: 70.0.w, width: 70.0.w, repeat: false),
                      Text(
                        LocaleKeys.search_product_not_found.tr(),
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            }

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

  Widget AndroidRefreshIndicator({NotiRespone item}){
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: Content_Main(item: item),
    );
  }

  Widget IOSRefreshIndicator({NotiRespone item}){
    return CustomRefreshIndicator(
      controller: _indicatorController,
      onRefresh: ()=>_refreshProducts(),
      armedToLoadingDuration: const Duration(seconds: 1),
      draggingToIdleDuration: const Duration(seconds: 1),
      completeStateDuration: const Duration(seconds: 1),
      offsetToArmed: 50.0,
      builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
          ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget _) {
                if (controller.state == IndicatorState.complete) {
                  // AudioCache().play("sound/Click.mp3");
                  // Vibration.vibrate(duration: 500);
                }
                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 2.0.h),
                    width: 5.0.w,
                    height: 5.0.w,
                    child: Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator(),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * _indicatorSize),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
      child: Content_Main(item: item),
    );
  }

  Widget  Content_Main({NotiRespone item}) => SingleChildScrollView(

    controller: _scrollController,
    child: Container(
      color: Colors.white,
      child: Column(
        children: [

          SizedBox(height: 1.5.h,),
          Column(

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
          if (item.data.length != item.total )
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Platform.isAndroid
                      ? SizedBox(width: 5.0.w,height: 5.0.w,child: CircularProgressIndicator())
                      : CupertinoActivityIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Loading",
                      style: FunctionHelper.FontTheme(
                          color: Colors.grey,
                          fontSize:
                          SizeUtil.priceFontSize()
                              .sp))
                ],
              ),
            ),
          SizedBox(height: 10.0.h,)
        ],
      ),
    ),
  );

  Container _BuildCardNoti({NotiData item,BuildContext context,int index}) => Container(

    child: GestureDetector(
        onTap: (){
          // if(item.Status_Sell==1)
          //   AppRoute.NotiDetail(context,"notiitem_${index}","notititle_${index}");
          // else
          //   item.Status_Sell!=2?AppRoute.OrderDetail(context,item.Status_Sell):print("press 2");
         // AppRoute.OrderDetail(context,orderData: OrderData(id: int.parse(item.meta.id)));
            if(CheckIsOrder(text: item.type)){
              AppRoute.OrderDetail(context,orderData: OrderData(id: int.parse(item.meta.id)),typeView: OrderViewType.Shop);
            }
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              padding: EdgeInsets.only(top: index==0?0.0.h:2.0.h,right: 10,left: 10,bottom: 2.0.h),
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
                        child:  Container(
                            child: Icon(
                              Icons.notifications_none,
                              size: 30,
                            )),
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 5),
                            child: ConvertStatus(item: item),
                          )),
                      CheckIsOrder(text: item.type)?Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black.withOpacity(0.4),
                        size: 4.0.w,
                      ):SizedBox()
                    ],
                  ),


                ],
              )
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              color: Colors.red,
              iconWidget: Column(
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
              onTap: () {
                var item = (bloc.onSuccess.value as NotiRespone);
                item.data.removeAt(index);
                bloc.onSuccess.add(item);
              },
            )

          ],
        )
    ),
  );


  Widget ConvertStatus({NotiData item}){
    if(item.type=="App\\Notifications\\Shop\\ShopUpdated"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("แจ้งเตือน อัพเดทข้อมูลร้านค้า",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(height: 0.5.h),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text: "อัพเดทข้อมูลร้านค้า ",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
                new TextSpan(text: "${item.meta.user}",style: FunctionHelper.FontTheme(fontSize: (SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor())),
               new TextSpan(text: " สำเร็จ ",style:FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
              ],
            ),
          ),
        /*  Wrap(
            children: [
              Text("อัพเดทข้อมูลร้านค้า ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
             Text("${item.meta.name}",style: FunctionHelper.FontTheme(fontSize: (SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor())),
              Text(" สำเร็จ ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
            ],
          )*/

        ],
      );
    }else if(item.type=="App\\Notifications\\Shop\\ShopIsLive" || item.type=="App\\Notifications\\Shop\\DownForMaintainace"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("แจ้งเตือน ${item.meta.status}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(height: 0.5.h),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text: "สถานะ ",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
                new TextSpan(text: "${item.meta.status} ",style: FunctionHelper.FontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.normal,color: Colors.black)),
                 ],
            ),
          ),
         /* Wrap(
            children: [
             Text("สถานะ ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
              Text("${item.meta.status} ",style: FunctionHelper.FontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.normal,color: Colors.black)),
            // Html(data: "สถานะ <span>${item.meta.status} ได้ทำการสั่งซื้อสินค้าเลขที่ออเดอร์ <b style='color:#006100'>${item.meta.order}</b></span> ",
             // ),
            ],
          )*/

        ],
      );
    }else if(item.type=="App\\Notifications\\Order\\MerchantOrderCreatedNotification"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("แจ้งเตือน คำสั่งซื้อใหม่",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(height: 0.5.h),
          //   Html(data: "<span>${item.meta.customer} ได้ทำการสั่งซื้อสินค้าเลขที่ออเดอร์ <b style='color:#006100'>${item.meta.order}</b></span> ",
          //      ),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text: "${item.meta.customer} ได้ทำการสั่งซื้อสินค้าเลขที่ออเดอร์",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
                new TextSpan(text: " ${item.meta.order}",style: FunctionHelper.FontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor()))
              ],
            ),
          ),


          //  Text("${item.meta.customer} ได้ทำการสั่งซื้อสินค้าเลขที่ออเดอร์ ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
          //  Text("${item.meta.order}",style: FunctionHelper.FontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor()))

        ],
      );
    }else if(item.type=="App\\Notifications\\Inventory\\StockOut"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("แจ้งเตือน: สินค้าหมด",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(height: 0.5.h),
          Text("จำนวนสินค้าหมด", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
        ],
      );
    }else if(item.type=="App\\Notifications\\Shop\\ShopCreated"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("แจ้งเตือน: เปิดร้านใหม่",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(height: 0.5.h),
          Text("${item.meta.name} ได้ทำการเปิดร้านใหม่", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
        ],
      );
    }else{
      return SizedBox();
    }

  }

  Future<Null>  _refreshProducts() async{
    if(Platform.isAndroid){
      await Future.delayed(Duration(seconds: 2));
      // AudioCache().play("sound/Click.mp3");
      // Vibration.vibrate(duration: 500);
    }
    page = 1;
    bloc.product_more.clear();
    bloc.refreshProducts(group: "shop",limit: limit,page: page);
  }

  @override
  bool get wantKeepAlive => true;


  bool CheckIsOrder({String text}){
    if(text=="App\\Notifications\\Order\\MerchantOrderCreatedNotification"){
      return true;
    }else {
      return false;
    }
  }

}




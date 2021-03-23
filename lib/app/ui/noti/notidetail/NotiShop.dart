import 'dart:io';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

//'assets/images/svg/cart_top.svg'
class NotiShop extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool btnBack;
  final NotiRespone notiRespone;
  const NotiShop(
      {Key key, this.btnBack = false, this.scaffoldKey, this.notiRespone})
      : super(key: key);
  @override
  _NotiShopState createState() => _NotiShopState();
}

class _NotiShopState extends State<NotiShop>
    with AutomaticKeepAliveClientMixin<NotiShop> {
  NotiBloc bloc;
  int limit = 10;
  int page = 1;
  bool stepPage = false;
  ScrollController _scrollController = ScrollController();
  bool warning = true;
  final _indicatorController = IndicatorController();
  static const _indicatorSize = 50.0;

  init() {
    if (bloc == null) {
      bloc = NotiBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context, title: LocaleKeys.btn_error.tr(), message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        // Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
      });

      //  bloc.onSuccess.add(widget.notiRespone);

    }

    NaiFarmLocalStorage.getNotiCache().then((value){
      if(value!=null){
        for(var data in value.notidata){
          if(data.typeView=="shop"){
            bloc.productMore.addAll(data.notiRespone.data);
            bloc.onSuccess.add(NotiRespone(
                data: bloc.productMore,
                limit: data.notiRespone.limit,
                page: data.notiRespone.page,
                total: data.notiRespone.total));
            break;
          }
        }
      }
    });
    page = 1;
    bloc.refreshProducts(context, group: "shop", limit: limit, page: page);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
          page++;
          bloc.refreshProducts(context,
              group: "shop", limit: limit, page: page);
        }
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    init();
    return Container(
      child: StreamBuilder(
        stream: bloc.feedList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var item = (snapshot.data as NotiRespone);
          if (snapshot.hasData) {
            stepPage = item.data.length != item.total ? true : false;
            if (item.data.isNotEmpty) {
              return Platform.isAndroid
                  ? androidRefreshIndicator(item: item)
                  : iosRefreshIndicator(item: item);
            } else {
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
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            }
          } else {
            return Container(
              margin: EdgeInsets.only(bottom: 15.0.h),
              child: Center(
                child: Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget androidRefreshIndicator({NotiRespone item}) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: contentMain(item: item),
    );
  }

  Widget iosRefreshIndicator({NotiRespone item}) {
    return CustomRefreshIndicator(
      controller: _indicatorController,
      onRefresh: () => _refreshProducts(),
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
      child: contentMain(item: item),
    );
  }

  Widget contentMain({NotiRespone item}) => SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Column(
                children: item.data
                    .asMap()
                    .map((index, value) {
                      return MapEntry(
                          index,
                          Column(
                            children: [
                              // if(CheckShowOrder(text: value.type))
                              buildCardNoti(
                                  item: value, context: context, index: index),
                            ],
                          ));
                    })
                    .values
                    .toList(),
              ),
              if (item.data.length != item.total && item.data.length > limit)
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Platform.isAndroid
                          ? SizedBox(
                              width: 5.0.w,
                              height: 5.0.w,
                              child: CircularProgressIndicator())
                          : CupertinoActivityIndicator(),
                      SizedBox(
                        width: 10,
                      ),
                      Text(LocaleKeys.dialog_message_loading.tr(),
                          style: FunctionHelper.fontTheme(
                              color: Colors.grey,
                              fontSize: SizeUtil.titleFontSize().sp))
                    ],
                  ),
                ),
              SizedBox(
                height: widget.btnBack?0.0.h:13.0.h,
              )
            ],
          ),
        ),
      );

  Container buildCardNoti({NotiData item, BuildContext context, int index}) =>
      Container(
        child: GestureDetector(
            onTap: () {
              // if(item.Status_Sell==1)
              //   AppRoute.NotiDetail(context,"notiitem_${index}","notititle_${index}");
              // else
              //   item.Status_Sell!=2?AppRoute.OrderDetail(context,item.Status_Sell):print("press 2");
              // AppRoute.OrderDetail(context,orderData: OrderData(id: int.parse(item.meta.id)));
              if (checkIsOrder(text: item.type)) {
                AppRoute.orderDetail(context,
                    orderData: OrderData(id: int.parse(item.meta.id)),
                    typeView: OrderViewType.Shop);
              }
            },
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                  decoration: BoxDecoration(
                    color: item.readAt != null
                        ? Colors.white
                        : ThemeColor.warning().withOpacity(0.6),
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey.shade200, width: 1)),
                  ),
                  padding: EdgeInsets.only(
                      top: 2.0.h, right: 10, left: 10, bottom: 2.0.h),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: Container(
                                child: Icon(
                              Icons.notifications_none,
                              size: 30,
                            )),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(left: 10, right: 5),
                            child: convertStatus(item: item),
                          )),
                          checkIsOrder(text: item.type)
                              ? Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black.withOpacity(0.4),
                                  size: 4.0.w,
                                )
                              : SizedBox()
                        ],
                      ),
                    ],
                  )),
              secondaryActions: <Widget>[
                IconSlideAction(
                  color: Colors.red,
                  iconWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/delete.json',
                          height: 4.0.h, width: 4.0.h, repeat: true),
                      Text(
                        LocaleKeys.cart_del.tr(),
                        style: FunctionHelper.fontTheme(
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
            )),
      );

  Widget convertStatus({NotiData item}) {
    if (item.type == "App\\Notifications\\Shop\\ShopUpdated") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${LocaleKeys.recommend_notification.tr()}: ${LocaleKeys.noti_shop_update.tr()}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 0.5.h),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text: "${LocaleKeys.noti_shop_update.tr()} ",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
                new TextSpan(
                    text: "${item.meta.user}",
                    style: FunctionHelper.fontTheme(
                        fontSize: (SizeUtil.titleSmallFontSize() - 1).sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.secondaryColor())),
                new TextSpan(
                    text: " ${LocaleKeys.dialog_message_success.tr()} ",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
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
    } else if (item.type == "App\\Notifications\\Shop\\ShopIsLive" ||
        item.type == "App\\Notifications\\Shop\\DownForMaintainace") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${LocaleKeys.recommend_notification.tr()}: ${item.meta.status}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 0.5.h),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text: "${LocaleKeys.noti_shop_status.tr()} ",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
                new TextSpan(
                    text: "${item.meta.status} ",
                    style: FunctionHelper.fontTheme(
                        fontSize: (SizeUtil.titleSmallFontSize() - 1).sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
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
    } else if (item.type ==
        "App\\Notifications\\Order\\MerchantOrderCreatedNotification") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${LocaleKeys.recommend_notification.tr()}: ${LocaleKeys.noti_shop_new_order.tr()}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 0.5.h),
          //   Html(data: "<span>${item.meta.customer} ได้ทำการสั่งซื้อสินค้าเลขที่ออเดอร์ <b style='color:#006100'>${item.meta.order}</b></span> ",
          //      ),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text:
                        "${item.meta.customer} ${LocaleKeys.noti_shop_orderid.tr()}",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
                new TextSpan(
                    text: " ${item.meta.order}",
                    style: FunctionHelper.fontTheme(
                        fontSize: (SizeUtil.titleSmallFontSize() - 1).sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeColor.secondaryColor()))
              ],
            ),
          ),

          //  Text("${item.meta.customer} ได้ทำการสั่งซื้อสินค้าเลขที่ออเดอร์ ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
          //  Text("${item.meta.order}",style: FunctionHelper.FontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor()))
        ],
      );
    } else if (item.type == "App\\Notifications\\Inventory\\StockOut") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${LocaleKeys.recommend_notification.tr()}: ${LocaleKeys.cart_outstock.tr()}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 0.5.h),
          Text("${LocaleKeys.noti_shop_outstock.tr()}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black)),
        ],
      );
    } else if (item.type == "App\\Notifications\\Shop\\ShopCreated") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${LocaleKeys.recommend_notification.tr()}: ${LocaleKeys.noti_shop_open.tr()}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 0.5.h),
          Text("${item.meta.name} ${LocaleKeys.noti_shop_open_detail.tr()}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black)),
        ],
      );
    } else if (item.type ==
        "App\\Notifications\\Order\\MerchantOrderRequestPaymentNotification") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${LocaleKeys.noti_rate1.tr()}${item.meta.order}  ${item.meta.image!=null?"${LocaleKeys.noti_shop_pay_upload.tr()}!":"${LocaleKeys.noti_shop_pay.tr()}"}",style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(height: 0.5.h),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text:"${item.meta.image!=null?"${item.meta.customer} ${LocaleKeys.noti_shop_pay_upload.tr()}":"${LocaleKeys.noti_shop_pay.tr()}"} ",
                    style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
                new TextSpan(text: "[${LocaleKeys.order_detail_order_num.tr()} ${item.meta.order} ]",style: FunctionHelper.fontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor())),

              ],
            ),
          ),
          // Text("${item.meta.customer} อัพโหลดเอกสารการชำระเงิน [หมายเลขคำสั่งซื้อ ${item.meta.order} ] กรุณาตรวจสอบรายละเอียด", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
        ],
      );
    } else if (item.type ==
        "App\\Notifications\\Order\\MerchantOrderRequestPaymentNotification") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${LocaleKeys.noti_rate1.tr()}${item.meta.order}  ${item.meta.image!=null?"${LocaleKeys.noti_shop_pay_upload.tr()}!":"${LocaleKeys.noti_shop_pay.tr()}"}",style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(height: 0.5.h),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text:"${item.meta.image!=null?"${item.meta.customer} ${LocaleKeys.noti_shop_pay_upload.tr()}":"${LocaleKeys.noti_shop_pay.tr()}"} ",
                    style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
                new TextSpan(text: "[${LocaleKeys.order_detail_order_num.tr()} ${item.meta.order} ]",style: FunctionHelper.fontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor())),

              ],
            ),
          ),
          // Text("${item.meta.customer} อัพโหลดเอกสารการชำระเงิน [หมายเลขคำสั่งซื้อ ${item.meta.order} ] กรุณาตรวจสอบรายละเอียด", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
        ],
      );
    } else if (item.type == "App\\Notifications\\Order\\MerchantOrderCanceledNotification") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${LocaleKeys.recommend_notification.tr()}: ${item.meta.status}",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 0.5.h),
          RichText(
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                new TextSpan(
                    text:"${item.meta.customerName} ${LocaleKeys.noti_shop_cancel.tr()}",
                    style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.normal,color: Colors.black)),
                new TextSpan(text: " ${item.meta.order}",style: FunctionHelper.fontTheme(fontSize:(SizeUtil.titleSmallFontSize()-1).sp,fontWeight: FontWeight.bold,color: ThemeColor.secondaryColor())),

              ],
            ),
          ),
        ],
      );
    }else {
      return SizedBox();
    }
  }

  Future<Null> _refreshProducts() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
      // AudioCache().play("sound/Click.mp3");
      // Vibration.vibrate(duration: 500);
    }
    page = 1;
    bloc.productMore.clear();
    bloc.refreshProducts(context, group: "shop", limit: limit, page: page);
  }

  @override
  bool get wantKeepAlive => true;

  bool checkIsOrder({String text}) {
    if (text == "App\\Notifications\\Order\\MerchantOrderCreatedNotification") {
      return true;
    } else if (text ==
        "App\\Notifications\\Order\\MerchantOrderRequestPaymentNotification") {
      return true;
    } else if (text ==
        "App\\Notifications\\Order\\MerchantOrderRequestPaymentNotification") {
      return false;
    } else {
      return false;
    }
  }

  // bool CheckShowOrder({String text}){
  //   if(text=="App\\Notifications\\Order\\MerchantOrderRequestPaymentNotification"){
  //     return false;
  //   }else {
  //     return true;
  //   }
  // }

}

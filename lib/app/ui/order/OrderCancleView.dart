import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class OrderCancleView extends StatefulWidget {
  final OrderData orderData;

  const OrderCancleView({Key key, this.orderData}) : super(key: key);
  @override
  _OrderCancleViewState createState() => _OrderCancleViewState();
}

class _OrderCancleViewState extends State<OrderCancleView> {
  OrdersBloc bloc;
  ProductBloc productBloc;
  bool onUpload = false;
  init() {
    if (bloc == null && productBloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      productBloc = ProductBloc(AppProvider.getApplication(context));
      if (widget.orderData.orderStatusName != null) {
        bloc.orderList.add(widget.orderData);
      }

      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.alertDialogShop(context,
            message: event, showbtn: true, title: LocaleKeys.btn_error.tr());
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        //onUpload = true;
        Navigator.pop(context, true);
      });

      productBloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      productBloc.onSuccess.stream.listen((event) {
        //onUpload = true;
        // if(event is CartResponse){
        //   AppRoute.MyCart(context, true,cart_nowId: Product_bloc.BayNow);
        //   // Usermanager().getUser().then((value) => bloc.GetMyWishlistsById(token: value.token,productId: widget.productItem.id));
        // }
      });
    }

    //  Usermanager().getUser().then((value) => bloc.GetOrderById(orderType: widget.typeView==OrderViewType.Shop?"myshop/orders":"order",id: widget.orderData.id, token: value.token));
    // Usermanager().getUser().then((value) => context.read<OrderBloc>().loadOrder(statusId: 1, limit: 20, page: 1, token: value.token));
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.order_detail_cancelled_buyer.tr(),
              headerType: Header_Type.barcartShop,
              showCartBtn: false,
              icon: '',
              onClick: () {
                Navigator.pop(context, onUpload);
              },
            ),
          ),
          body: StreamBuilder(
            stream: bloc.orderList.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var item = (snapshot.data as OrderData);
                if (snapshot.data != null) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //widget.typeView==OrderViewType.Purchase &&  item.orderStatusId!=5 &&  item.orderStatusId!=6 &&  item.orderStatusId!=8?_HeaderStatus(context: context,orderData: item):SizedBox(),
                                headerStatus(context: context, orderData: item),
                                SizedBox(height: 1.0.h),
                                itemInfo(
                                    pricecolorText: ThemeColor.colorSale(),
                                    leading:
                                        LocaleKeys.order_detail_refund.tr(),
                                    trailing:
                                        //"฿${NumberFormat("#,##0.00", "en_US").format(item.grandTotal)}"),
                                        "฿${item.grandTotal}"),
                                SizedBox(height: 1.0.h),
                                itemInfo(
                                    pricecolorText: Colors.grey.shade500,
                                    leading: LocaleKeys
                                        .order_detail_cancelled_by
                                        .tr(),
                                    trailing:
                                        LocaleKeys.order_detail_buyer.tr()),
                                itemInfo(
                                    pricecolorText: Colors.grey.shade500,
                                    leading: LocaleKeys
                                        .order_detail_cancelled_time
                                        .tr(),
                                    trailing:
                                        "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(DateTime.now().toString()))} "),

                                itemInfo(
                                    pricecolorText: Colors.grey.shade500,
                                    leading: LocaleKeys
                                        .order_detail_cancelled_reason
                                        .tr(),
                                    trailing: "สินค้าเสียหาย"),
                                SizedBox(height: 1.0.h),
                                Container(
                                  padding: EdgeInsets.all(3.0.w),
                                  color: Colors.white,
                                  child: Column(
                                    children: item.items
                                        .asMap()
                                        .map((key, value) => MapEntry(
                                            key,
                                            Column(
                                              children: [
                                                itemProduct(
                                                    orderItems:
                                                        item.items[key]),
                                                SizedBox(
                                                  height: 1.0.h,
                                                )
                                              ],
                                            )))
                                        .values
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: 1.0.h),
                                buttonConfirm(context: context, orderData: item)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(color: Colors.white, child: SizedBox());
                }
              } else {
                return Container(
                    color: Colors.white,
                    child: Center(
                      child: Platform.isAndroid
                          ? SizedBox(
                              width: 5.0.w,
                              height: 5.0.w,
                              child: CircularProgressIndicator())
                          : CupertinoActivityIndicator(),
                    ));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buttonConfirm({BuildContext context, OrderData orderData}) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(1.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(1.0.h),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(60.0.w, 6.0.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    ThemeColor.colorSale(),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                ),
                onPressed: () {
                  FunctionHelper.confirmDialog(context,
                      message: "คุณได้ตอบรับคำขอยกเลิกคำสั่งซื้อสินค้านี้ ?",
                      onCancel: () {
                    Navigator.of(context).pop();
                  }, onClick: () {
                    Navigator.of(context).pop();
                    //  AppRoute.SellerCanceled(context: context,orderData: widget.orderData,typeView: orderViewType);
                  });
                },
                child: Text(
                  LocaleKeys.btn_reject_order.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(1.0.h),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(60.0.w, 6.0.h),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      ThemeColor.secondaryColor(),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    FunctionHelper.confirmDialog(context,
                        message: "คุณได้ตอบรับคำขอยกเลิกคำสั่งซื้อสินค้านี้ ?",
                        onCancel: () {
                      Navigator.of(context).pop();
                    }, onClick: () {
                      Navigator.of(context).pop();
                      //  AppRoute.SellerCanceled(context: context,orderData: widget.orderData,typeView: orderViewType);
                    });
                  },
                  child: Text(
                    LocaleKeys.btn_accept_order.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemProduct({OrderItems orderItems}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.1))),
          child: CachedNetworkImage(
            width: 22.0.w,
            height: 22.0.w,
            placeholder: (context, url) => Container(
              width: 22.0.w,
              height: 22.0.w,
              color: Colors.white,
              child: Lottie.asset('assets/json/loading.json', height: 30),
            ),
            fit: BoxFit.cover,
            imageUrl:
                "${Env.value.baseUrl}/storage/images/${orderItems.inventory.product.image.isNotEmpty ? orderItems.inventory.product.image[0].path : ''}",
            errorWidget: (context, url, error) => Container(
                width: 22.0.w,
                height: 22.0.w,
                child: Icon(
                  Icons.error,
                  size: 30,
                )),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${orderItems.inventory.title}",
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("x ${orderItems.quantity}",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      // Text("฿${orderItems.inventory.offerPrice}",
                      //     style: FunctionHelper.fontTheme(
                      //         fontSize: SizeUtil.titleFontSize().sp,
                      //         decoration: TextDecoration.lineThrough,color: Colors.black.withOpacity(0.5))),
                      // SizedBox(width: 8),
                      //Text("฿${NumberFormat("#,##0.00", "en_US").format(orderItems.inventory.salePrice*orderItems.quantity)}",
                      Text(
                          "฿${orderItems.inventory.salePrice * orderItems.quantity}",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              color: Colors.black))
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget itemInfo(
      {Color pricecolorText, String leading = "", String trailing = ""}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1)),
      ),
      child: ListTile(
          leading: Text(
            leading,
            style: FunctionHelper.fontTheme(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          trailing: Text(
            trailing,
            style: FunctionHelper.fontTheme(
                color: pricecolorText,
                fontWeight: FontWeight.normal,
                fontSize: SizeUtil.titleSmallFontSize().sp),
          )),
    );
  }

  Widget headerStatus({BuildContext context, OrderData orderData}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
              border: Border.all(
                  width: 3, color: Colors.white, style: BorderStyle.solid)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 4.0.h,
            ),
            // Text("Order ${orderData.orderNumber}",style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold),),
            //SizedBox(height: 3),
            RichText(
              text: new TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  new TextSpan(
                      text:
                          "คุณสามารถตอบรับหรือปฏิเสธคำขอยกเลิก โดยตอบกลับภายใน  ",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black.withOpacity(0.8))),
                  new TextSpan(
                      text:
                          "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.requirePaymentAt != null ? orderData.requirePaymentAt : DateTime.now().toString()))} ",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: Colors.black.withOpacity(0.5))),
                  //new TextSpan(text: " จัดส่งแล้วเมื่อ ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.meta.requirePaymentAt!=null?item.meta.requirePaymentAt:DateTime.now().toString()))}",
                  //     style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.8))),
                  new TextSpan(
                      text: " ไม่เช่นนั้นคำสั่งซื้อจะถูกยกเลิกโดยอัตโนมัติ",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black.withOpacity(0.8))),
                ],
              ),
            ),
          ]),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: headerStatusText(orderData: orderData),
        )
      ],
    );
  }

  Widget headerStatusText({OrderData orderData}) {
    return Container(
      width: 70.0.w,
      height: 6.0.h,
      margin: EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.only(right: 13, left: 10, top: 5, bottom: 5),
          color: ThemeColor.primaryColor(),
          child: Center(
              child: Text(
            "ผู้ซื้อขอยกเลิกคำสั่งซื้อ",
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:sizer/sizer.dart';

class ConfirmPaymentView extends StatelessWidget {
  final OrderData orderData;
  final BuildContext contextMain;

  ConfirmPaymentView({Key key, this.orderData, this.contextMain})
      : super(key: key);

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  OrdersBloc bloc;

  init(BuildContext context) {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      bloc.onSuccess.add(orderData);
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        // FunctionHelper.AlertDialogRetry(contextMain,title: "Error",message: event,callBack: (){
        //   Usermanager().getUser().then((value) => bloc.GetOrderById(orderType: "myshop/order",id: orderData.id, token: value.token));
        // });
        FunctionHelper.AlertDialogShop(contextMain,
            title: "Error", message: event, showbtn: true);
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        // Navigator.pop(context,true);
      });
      Usermanager().getUser().then((value) => bloc.GetOrderById(
          orderType: "myshop/orders", id: orderData.id, token: value.token));
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
          backgroundColor: Colors.grey.shade200,
          appBar: AppToobar(
            title: "Confirm payment of order ",
            header_type: Header_Type.barcartShop,
            isEnable_Search: false,
            icon: '',
            onClick: () {
              Navigator.pop(context, false);
            },
          ),
          body: StreamBuilder(
            stream: bloc.feedList,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var item = (snapshot.data as OrderData);
                if (snapshot.data != null) {
                  return Container(
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              ItemInfo(
                                  PricecolorText: ThemeColor.ColorSale(),
                                  leading: "All buyer payment ",
                                  trailing:
                                      "฿${NumberFormat("#,##0.00", "en_US").format(item.grandTotal)}"),
                              SizedBox(height: 1.0.h),
                              ItemInfo(
                                  PricecolorText: Colors.grey.shade400,
                                  leading: "Total product cost",
                                  trailing:
                                      "฿${NumberFormat("#,##0.00", "en_US").format(item.total)}"),
                              ItemInfo(
                                  PricecolorText: Colors.grey.shade400,
                                  leading: "Shipping cost",
                                  trailing:
                                      "฿${NumberFormat("#,##0.00", "en_US").format(item.shipping)}"),
                              ItemInfo(
                                  PricecolorText: Colors.grey.shade400,
                                  leading: "Discount code",
                                  trailing:
                                      "฿${NumberFormat("#,##0.00", "en_US").format(item.discount)}"),
                              SizedBox(height: 1.0.h),
                              ItemInfo(
                                  PricecolorText: Colors.grey.shade400,
                                  leading: "Payment method",
                                  trailing: "${item.paymentMethod.name}"),
                              item.image!=null && item.image.length>0
                                  ? Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(5.0.w),
                                    child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "Proof of transfer ",
                                      style: FunctionHelper.FontTheme(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: SizeUtil.titleSmallFontSize().sp),
                                    ),
                                    SizedBox(height: 2.0.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade400,width: 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)
                                        ),
                                      ),
                                      padding: EdgeInsets.all(2.0.h),
                                      child: FullScreenWidget(
                                        backgroundIsTransparent: true,
                                        child: Center(
                                          child: Hero(
                                            tag: "payment",
                                            child: CachedNetworkImage(
                                              // placeholder: (context, url) => Container(
                                              //   child: Lottie.asset('assets/json/loading.json', ),
                                              // ),
                                              imageUrl: ProductLandscape.CovertUrlImage(item.image),
                                              //  errorWidget: (context, url, error) => Container(child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                                  )
                                  : SizedBox()
                            ],
                          ),
                        )),
                        _ButtonActive(context: context, orderData: item)
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

  Widget ItemInfo(
      {Color PricecolorText, String leading = "", String trailing = ""}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1)),
      ),
      padding: EdgeInsets.all(1.0.w),
      child: ListTile(
          leading: Text(
            leading,
            style: FunctionHelper.FontTheme(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          trailing: Text(
            trailing,
            style: FunctionHelper.FontTheme(
                color: PricecolorText,
                fontWeight: FontWeight.normal,
                fontSize: SizeUtil.titleSmallFontSize().sp),
          )),
    );
  }

  Widget _ButtonActive({BuildContext context, OrderData orderData}) {
    return Center(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(2.0.w),
        child: Center(
          child: FlatButton(
            minWidth: 50.0.w,
            height: 5.0.h,
            color: ThemeColor.ColorSale(),
            textColor: Colors.white,
            splashColor: Colors.white.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            onPressed: () {
              FunctionHelper.ConfirmDialog(context,
                  message: "คุณต้องการยืนยันการชำระเงินคำสั่งซื้อสินค้านี้ ?",
                  onCancel: () {
                Navigator.of(context).pop();
              }, onClick: () {
                Navigator.of(context).pop();
                Usermanager().getUser().then((value) =>
                    bloc.MarkPaid(token: value.token, OrderId: orderData.id));
              });
            },
            child: Text(
              "Confirm ",
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

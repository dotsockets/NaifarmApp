import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

// ignore: must_be_immutable
class ConfirmPaymentView extends StatelessWidget {
  final OrderData orderData;
  final BuildContext contextMain;

  ConfirmPaymentView({Key key, this.orderData, this.contextMain})
      : super(key: key);

  OrdersBloc bloc;
  bool onDialog = false;
  bool onUpload = false;

  init(BuildContext context) {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));

      bloc.orderList.add(orderData);
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
        FunctionHelper.alertDialogShop(contextMain,
            title: LocaleKeys.btn_error.tr(), message: event, showbtn: true);
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is bool) {
          onDialog = true;
          FunctionHelper.successDialog(context,
              message: LocaleKeys.dialog_message_success_pay.tr(),
              onClick: () {},
              barrierDismissible: false);
          Future.delayed(const Duration(milliseconds: 800), () {
            onUpload = true;
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          });
        }
      });
      _getOrder(context);
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.5.h),
            child: AppToobar(
              title: LocaleKeys.order_detail_confirm_pay.tr(),
              headerType: Header_Type.barcartShop,
              isEnableSearch: false,
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
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              item.grandTotal != null
                                  ? itemInfo(
                                      pricecolorText: ThemeColor.colorSale(),
                                      leading: LocaleKeys.order_detail_total_pay
                                          .tr(),
                                      trailing:
                                          "฿${item.grandTotal}")
                                  : SizedBox(),
                              SizedBox(height: 1.0.h),
                              item.total != null
                                  ? itemInfo(
                                      pricecolorText: Colors.grey.shade400,
                                      leading:
                                          LocaleKeys.order_detail_subtotal.tr(),
                                      trailing:
                                          "฿${item.total}")
                                  : SizedBox(),
                              item.shipping != null
                                  ? itemInfo(
                                      pricecolorText: Colors.grey.shade400,
                                      leading: LocaleKeys
                                          .order_detail_ship_price
                                          .tr(),
                                      trailing:
                                          //"฿${NumberFormat("#,##0.00", "en_US").format(item.shipping)}"):SizedBox(),
                                          "฿${item.shipping}")
                                  : SizedBox(),
                              // item.discount!=null?ItemInfo(
                              //     PricecolorText: Colors.grey.shade400,
                              //     leading: "Discount code",
                              //     trailing:
                              //         "฿${NumberFormat("#,##0.00", "en_US").format(item.discount)}"):SizedBox(),
                              SizedBox(height: 1.0.h),
                              item.discount != null
                                  ? itemInfo(
                                      pricecolorText: Colors.grey.shade400,
                                      leading: LocaleKeys.me_title_payment.tr(),
                                      trailing: "${item.paymentMethod.name}")
                                  : SizedBox(),
                              item.image != null && item.image.length > 0
                                  ? Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(5.0.w),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              LocaleKeys.payment_method_slip
                                                  .tr(),
                                              style: FunctionHelper.fontTheme(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: SizeUtil
                                                          .titleSmallFontSize()
                                                      .sp),
                                            ),
                                            SizedBox(
                                              height: 2.0.h,
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                padding: EdgeInsets.all(2.0.h),
                                                child: FullScreenWidget(
                                                    backgroundIsTransparent:
                                                        true,
                                                    child: Center(
                                                      child:
                                                          /*Hero(
                                                      tag: "payment",
                                                      child:*/
                                                          CachedNetworkImage(
                                                        // placeholder: (context, url) => Container(
                                                        //   child: Lottie.asset('assets/json/loading.json', ),
                                                        // ),
                                                        imageUrl:item.image.length != 0?
                                                        "${item.image[0].path.imgUrl()}":""
                                                        //  errorWidget: (context, url, error) => Container(child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
                                                      ),
                                                    ))) //)
                                          ]),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        )),
                        buttonActive(context: context, orderData: item)
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

  Widget itemInfo(
      {Color pricecolorText, String leading = "", String trailing = ""}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade400, width: 1)),
      ),
      padding: EdgeInsets.all(1.0.w),
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

  Widget buttonActive({BuildContext context, OrderData orderData}) {
    return Center(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(2.0.w),
        child: Center(
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(50.0.w, 5.0.h),
              ),
              backgroundColor: MaterialStateProperty.all(
                orderData.image != null
                    ? orderData.image.isNotEmpty
                        ? ThemeColor.colorSale()
                        : Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () {
              if (orderData.image.isNotEmpty) {
                FunctionHelper.confirmDialog(context,
                    message: "${LocaleKeys.dialog_message_confirm_pay.tr()} ?",
                    onCancel: () {
                  Navigator.of(context).pop();
                }, onClick: () {
                  Navigator.of(context).pop();
                  onUpload = true;
                  Usermanager().getUser().then((value) => bloc.markPaid(context,
                      token: value.token, orderId: orderData.id));
                });
              }
            },
            child: Text(
              LocaleKeys.btn_confirm.tr(),
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
  _getOrder(BuildContext context){
    Usermanager().getUser().then((value) => bloc.getOrderById(context,
        orderType: "myshop/orders", id: orderData.id, token: value.token));
  }
}

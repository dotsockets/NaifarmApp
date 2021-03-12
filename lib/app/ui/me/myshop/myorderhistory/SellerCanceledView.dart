import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:sizer/sizer.dart';

class SellerCanceledView extends StatefulWidget {
  final OrderData orderData;
  final OrderViewType typeView;

  const SellerCanceledView({Key key, this.orderData, this.typeView})
      : super(key: key);
  @override
  _SellerCanceledViewState createState() => _SellerCanceledViewState();
}

class _SellerCanceledViewState extends State<SellerCanceledView> {
  OrdersBloc bloc;
  TextEditingController detailtController = TextEditingController();

  init(BuildContext context) {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));

      if (widget.orderData.grandTotal != null) {
        bloc.orderList.add(widget.orderData);
      }

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
        FunctionHelper.alertDialogShop(context,
            title: "Error", message: event, showbtn: true);
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        // Navigator.pop(context,true);
      });

      Usermanager().getUser().then((value) => bloc.getOrderById(context,
          orderType:
              widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
          id: widget.orderData.id,
          token: value.token));
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
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: "The seller canceled the order",
              headerType: Header_Type.barcartShop,
              isEnableSearch: false,
              icon: '',
              onClick: () {
                Navigator.pop(context, false);
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
                              itemInfo(
                                  pricecolorText: ThemeColor.colorSale(),
                                  leading:
                                      "The amount to be refunded (Including shipping) ",
                                  trailing:
                                      "฿${NumberFormat("#,##0.00", "en_US").format(item.grandTotal)}"),
                              SizedBox(height: 1.0.h),
                              itemInfo(
                                  pricecolorText: Colors.grey.shade500,
                                  leading: "Stand by ",
                                  trailing: "Seller "),
                              itemInfo(
                                  pricecolorText: Colors.grey.shade500,
                                  leading: "Cancellation date ",
                                  trailing:
                                      "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(DateTime.now().toString()))} "),
                              ListMenuItem(
                                icon: "",
                                fontWeight: FontWeight.normal,
                                title: "Reason for cancellation ",
                                message: "Choose a reason ",
                                onClick: () {
                                  _showMyDialog(context);
                                },
                              ),
                              itemFormDetail()
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

  Widget itemFormDetail() {
    return Container(
      padding: EdgeInsets.all(2.0.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: Colors.grey.shade400, width: 1),
            top: BorderSide(color: Colors.grey.shade400, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Specify details ",
            style: FunctionHelper.fontTheme(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          BuildEditText(
            enableMaxLength: false,
            maxLength: 5000,
            borderOpacity: 0.3,
            hint: "Specify details",
            maxLine: 5,
            controller: detailtController,
            inputType: TextInputType.text,
            onChanged: (String char) {
              if (char.isNotEmpty) {}
            },
          )
        ],
      ),
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
                ThemeColor.colorSale(),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () {
              FunctionHelper.confirmDialog(context,
                  message:
                      "Would you like to cancel your order for this product ?",
                  onCancel: () {
                Navigator.of(context).pop();
              }, onClick: () {
                Navigator.of(context).pop();
                Usermanager().getUser().then((value) => bloc.markPaid(context,
                    token: value.token, orderId: orderData.id));
              });
            },
            child: Text(
              "Confirm ",
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

  Future<void> _showMyDialog(BuildContext context) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: InkWell(
            onTap: () {
              // onClick();
            },
            child: Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: ThemeColor.dialogprimaryColor(context),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade400, width: 1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                              child: Text(
                            "Select a reason for cancellation",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1)),
                                  ),
                                  padding: const EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Out of stock ",
                                    style: FunctionHelper.fontTheme(
                                        color: Colors.grey.shade700,
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1)),
                                  ),
                                  padding: const EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Payment not received ",
                                    style: FunctionHelper.fontTheme(
                                        color: Colors.grey.shade700,
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              )
            ])),
          ),
        );
      },
    );
  }
}

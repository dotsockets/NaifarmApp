import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class OrderView extends StatefulWidget {
  final OrderData orderData;
  final OrderViewType typeView;
  OrderView({Key key, this.orderData, this.typeView}) : super(key: key);
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  OrdersBloc bloc;
  ProductBloc productBloc;
  bool onUpload = false;
  init() {
    if (bloc == null && productBloc == null) {
      // OneSignalCall.cancelNotification("orderView", widget.orderData.id,
      //     orderNumber: widget.orderData.orderNumber);
      bloc = OrdersBloc(AppProvider.getApplication(context));
      productBloc = ProductBloc(AppProvider.getApplication(context));

      NaiFarmLocalStorage.getOrderCache().then((value) {
        if (value != null) {
          var orderType =
              widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order";
          for (var data in value.orderCahe) {
            if (data.typeView == widget.orderData.id.toString() &&
                data.orderViewType == orderType) {
              bloc.orderList.add(data.orderData);
              break;
            }
          }
        } else {
          if (widget.orderData.orderStatusName != null) {
            bloc.orderList.add(widget.orderData);
          }
        }
      });

      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.alertDialogShop(context,
            message: event,
            showbtn: true,
            title: LocaleKeys.btn_error.tr(), callCancle: () {
          AppRoute.poppageCount(context: context, countpage: 2);
        });
        //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      productBloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.alertDialogShop(context,
            message: event.message,
            showbtn: true,
            title: LocaleKeys.btn_error.tr());
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
        if (event is CartResponse) {
          AppRoute.myCart(context, true, cartNowId: productBloc.bayNow);
          // Usermanager().getUser().then((value) => bloc.GetMyWishlistsById(token: value.token,productId: widget.productItem.id));
        }
      });
    }

    Usermanager().getUser().then((value) => bloc.getOrderById(context,
        orderType:
            widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
        id: widget.orderData.id,
        token: value.token));
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
              title: widget.typeView == OrderViewType.Shop
                  ? LocaleKeys.order_detail_sell.tr()
                  : LocaleKeys.order_detail_title.tr(),
              headerType: Header_Type.barcartShop,
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
                                item.orderStatusId == 1 &&
                                            widget.typeView ==
                                                OrderViewType.Purchase ||
                                        item.orderStatusId == 3 &&
                                            widget.typeView ==
                                                OrderViewType.Purchase
                                    ? headerStatus(
                                        context: context, orderData: item)
                                    : SizedBox(),
                                _labelText(
                                    title:
                                        LocaleKeys.order_detail_ship_addr.tr()),
                                addressRecive(
                                    context: context, orderData: item),
                                _labelText(
                                    title:
                                        LocaleKeys.order_detail_ship_data.tr()),
                                item.carrier != null
                                    ? shippingInformation(
                                        context: context, orderData: item)
                                    : SizedBox(),
                                item.carrier != null
                                    ? SizedBox(
                                        height: 15,
                                      )
                                    : SizedBox(),
                                orderNumberInformation(
                                    context: context,
                                    orderData: item,
                                    rateDelivery: item.shipping),
                                _labelText(
                                    title:
                                        LocaleKeys.order_detail_payment.tr()),
                                paymentInfo(context: context, orderData: item),
                                SizedBox(
                                  height: 15,
                                ),
                                timelineOrder(context: context, orderData: item)
                              ],
                            ),
                          ),
                        ),
                        widget.typeView == OrderViewType.Shop &&
                                item.orderStatusId == 1
                            ? buttonConfirmPay(
                                context: context,
                                orderData: item,
                                orderViewType: OrderViewType.Shop)
                            : SizedBox(),
                        widget.typeView == OrderViewType.Shop &&
                                item.orderStatusId == 3
                            ? buttonShipping(context: context, orderData: item)
                            : SizedBox(),

                        // widget.typeView==OrderViewType.Purchase && item.orderStatusId==3? _ButtonCancel(context: context,orderData: item,orderViewType: OrderViewType.Purchase):SizedBox(),
                        widget.typeView == OrderViewType.Purchase &&
                                item.orderStatusId == 1
                            ? buttonCancel(
                                context: context,
                                orderData: item,
                                orderViewType: OrderViewType.Purchase)
                            : SizedBox(),

                        widget.typeView == OrderViewType.Purchase &&
                                (item.orderStatusId == 5 ||
                                    item.orderStatusId == 4)
                            ? buttonAcceptProducts(
                                context: context, orderData: item)
                            : SizedBox(),
                        widget.typeView == OrderViewType.Purchase &&
                                item.orderStatusId == 6
                            ? buttonSuccess(context: context, item: item)
                            : SizedBox(),
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

  Widget headerStatusText({OrderData orderData}) {
    return Container(
      width: 70.0.w,
      height: 6.0.h,
      margin: EdgeInsets.only(top: 2.0.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.only(right: 13, left: 10, top: 5, bottom: 5),
          color: ThemeColor.primaryColor(),
          child: Center(
              child: Text(
            orderData.orderStatusName,
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
        ),
      ),
    );
  }

  Widget headerStatus({BuildContext context, OrderData orderData}) {
    return InkWell(
      onTap: () async {
        final result = await AppRoute.transferPayMentView(
            context: context, orderData: orderData);

        if (result) {
          //bloc.orderDataList.clear();
          Usermanager().getUser().then((value) => bloc.getOrderById(context,
              orderType: widget.typeView == OrderViewType.Shop
                  ? "myshop/orders"
                  : "order",
              id: widget.orderData.id,
              token: value.token));
        }
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 5.0.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
                border: Border.all(
                    width: 3, color: Colors.white, style: BorderStyle.solid)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 2.0.h,
              ),
              // Text("Order ${orderData.orderNumber}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold),),
              //SizedBox(height: 3),
              orderData.orderStatusId == 1
                  ? RichText(
                      text: new TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          new TextSpan(
                              text:
                                  "${LocaleKeys.order_detail_please.tr()}${LocaleKeys.order_detail_pay_date.tr()} ",
                              style: FunctionHelper.fontTheme(
                                  fontSize:
                                      SizeUtil.spanTitleSmallFontSize().sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.8))),
                          new TextSpan(
                              text:
                                  "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.requirePaymentAt != null ? orderData.requirePaymentAt : DateTime.now().toString()))} ",
                              style: FunctionHelper.fontTheme(
                                  fontSize:
                                      SizeUtil.spanTitleSmallFontSize().sp,
                                  color: Colors.black.withOpacity(0.5))),
                          //new TextSpan(text: " จัดส่งแล้วเมื่อ ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.meta.requirePaymentAt!=null?item.meta.requirePaymentAt:DateTime.now().toString()))}",
                          //     style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.8))),
                          new TextSpan(
                              text: " ${LocaleKeys.order_detail_cancel.tr()}",
                              style: FunctionHelper.fontTheme(
                                  fontSize:
                                      SizeUtil.spanTitleSmallFontSize().sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.8))),
                        ],
                      ),
                    )
                  : RichText(
                      text: new TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          new TextSpan(
                              text:
                                  "${LocaleKeys.order_detail_ship_date_header.tr()} ",
                              style: FunctionHelper.fontTheme(
                                  fontSize:
                                      SizeUtil.spanTitleSmallFontSize().sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.8))),
                          new TextSpan(
                              text:
                                  "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.paymentAt != null ? orderData.paymentAt : DateTime.now().toString()))} ",
                              style: FunctionHelper.fontTheme(
                                  fontSize:
                                      SizeUtil.spanTitleSmallFontSize().sp,
                                  color: Colors.black.withOpacity(0.5))),
                          //new TextSpan(text: " จัดส่งแล้วเมื่อ ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.meta.requirePaymentAt!=null?item.meta.requirePaymentAt:DateTime.now().toString()))}",
                          //     style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.8))),
                        ],
                      ),
                    )
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: headerStatusText(orderData: orderData),
          )
        ],
      ),
    );
  }

  Widget _labelText({String title}) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
      child: Text(
        title,
        style: FunctionHelper.fontTheme(
            fontSize: SizeUtil.titleSmallFontSize().sp,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget addressRecive({BuildContext context, OrderData orderData}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orderData.shippingAddressTitle != null
              ? Text(
                  orderData.shippingAddressTitle,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: ThemeColor.primaryColor(),
                      fontWeight: FontWeight.bold,
                      height: 1.5),
                )
              : SizedBox(),
          orderData.shippingAddressPhone != null
              ? Text(
                  orderData.shippingAddressPhone,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                )
              : SizedBox(),
          orderData.shippingAddress != null
              ? Text(
                  orderData.shippingAddress,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget shippingInformation({BuildContext context, OrderData orderData}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orderData.carrier != null ? orderData.carrier.name : '',
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                color: ThemeColor.primaryColor(),
                fontWeight: FontWeight.bold,
                height: 1.5),
          ),
          SizedBox(height: 1.0.w),
          Text(
            orderData.trackingId != null ? orderData.trackingId : '-',
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.5),
          ),
          orderData.deliveryDate != null ? SizedBox(height: 1.0.w) : SizedBox(),
          orderData.deliveryDate != null
              ? Text(
                  "${LocaleKeys.history_receipt_time.tr()} ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.deliveryDate.toString()))} ",
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                )
              : SizedBox(),
          // SizedBox(height: 6),
          //  Text("${orderData.shippingRate.deliveryTakes} ",style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
        ],
      ),
    );
  }

  Widget orderNumberInformation(
      {BuildContext context, OrderData orderData, int rateDelivery}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_order_num.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                orderData.orderNumber,
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: ThemeColor.colorSale(),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        width: 30,
                        height: 30,
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                          child: Lottie.asset('assets/json/loading.json',
                              height: 30),
                        ),
                        fit: BoxFit.cover,
                        imageUrl:
                            "${Env.value.baseUrl}/storage/images/${orderData.shop.image.isNotEmpty ? orderData.shop.image[0].path : ''}",
                        // errorWidget: (context, url, error) => Container(
                        //     width: 30,
                        //     height: 30,
                        //     child: CircleAvatar(
                        //       backgroundColor: Color(0xffE6E6E6),
                        //       radius: 25,
                        //       child: Icon(
                        //         Icons.shopping_bag_rounded,
                        //         color: Color(0xffCCCCCC),
                        //       ),
                        //     )),
                        errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade300,
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.person,
                              size: 5.0.w,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      orderData.shop.name,
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          height: 1.5),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 0.8.h),
                        child: Text(
                          LocaleKeys.order_detail_go_shop.tr(),
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        )),
                    SizedBox(
                      width: 1.0.w,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade400,
                      size: SizeUtil.ratingSize().w,
                    )
                  ],
                ),
              ],
            ),
            onTap: () {
              var item = orderData.shop;
              AppRoute.shopMain(
                  context: context,
                  myShopRespone: MyShopRespone(
                      id: item.id,
                      name: item.name,
                      image: item.image,
                      updatedAt: item.updatedAt));
            },
          ),
          SizedBox(
            height: 13,
          ),
          Column(
            children: orderData.items
                .asMap()
                .map((key, value) => MapEntry(
                    key,
                    Column(
                      children: [
                        itemProduct(orderItems: orderData.items[key]),
                        SizedBox(
                          height: 1.0.h,
                        )
                      ],
                    )))
                .values
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_subtotal.tr() + " :",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                  "฿${NumberFormat("#,##0", "en_US").format(bloc.sumTotal(orderData.items, 0))}",
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: Colors.black))
              // Text("฿${sumTotal}",
              //     style: FunctionHelper.FontTheme(
              //         fontSize: SizeUtil.titleFontSize().sp,
              //         color: Colors.black))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_ship_price.tr() + " :",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                  "฿${NumberFormat("#,##0", "en_US").format(rateDelivery != null ? rateDelivery : 0)}",
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: Colors.black))
              // Text("฿${rate_delivery != null ? rate_delivery : 0}",
              //     style: FunctionHelper.FontTheme(
              //         fontSize: SizeUtil.titleFontSize().sp,
              //         color: Colors.black))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_total.tr() + " :",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                  "฿${NumberFormat("#,##0", "en_US").format(bloc.sumTotal(orderData.items, rateDelivery != null ? rateDelivery : 0))}",
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: ThemeColor.colorSale()))
              // Text("฿${sumTotal + (rate_delivery != null ? rate_delivery : 0)}",
              //     style: FunctionHelper.FontTheme(
              //         fontSize: SizeUtil.titleFontSize().sp,
              //         color: ThemeColor.ColorSale()))
            ],
          ),
        ],
      ),
    );
  }

  Widget itemProduct({OrderItems orderItems}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          child: Hero(
            tag: "orderview_${orderItems.inventoryId}1",
            child: Container(
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
                imageUrl: orderItems.itemImagePath != null
                    ? "${Env.value.baseUrl}/storage/images/${orderItems.itemImagePath}"
                    : Env.value.noItemUrl,
                errorWidget: (context, url, error) => Container(
                    width: 22.0.w,
                    height: 22.0.w,
                    child: Icon(
                      Icons.error,
                      size: 30,
                    )),
              ),
            ),
          ),
          onTap: () {
            if (orderItems.inventory != null) {
              // ignore: unused_local_variable
              ProductData product = ProductData();
              product = orderItems.inventory.product;
              AppRoute.productDetail(context,
                  productImage: "orderview_${orderItems.inventoryId}1",
                  productItem: ProducItemRespone(
                      id: orderItems.inventory.product.id,
                      image: orderItems.inventory.image));
            }
          },
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${orderItems.inventory != null ? orderItems.inventory.title : orderItems.itemTitle}",
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
                      //   item.ProductDicount != 0 ?
                      orderItems.unitPrice != null &&
                              orderItems.offerPrice != null &&
                              double.parse(orderItems.offerPrice.toString()) > 0
                          ? Text(
                              "฿${NumberFormat("#,##0", "en_US").format(double.parse(orderItems.unitPrice))}",
                              style: FunctionHelper.fontTheme(
                                  color: Colors.grey,
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  decoration: TextDecoration.lineThrough))
                          : SizedBox(),
                      SizedBox(
                          width: orderItems.unitPrice != null &&
                                  orderItems.offerPrice != null
                              ? 1.0.w
                              : 0),
                      Text(
                        orderItems.offerPrice != null &&
                                double.parse(
                                        orderItems.offerPrice.toString()) !=
                                    0
                            ? "฿${NumberFormat("#,##0", "en_US").format(double.parse(orderItems.offerPrice.toString()))}"
                            : "฿${NumberFormat("#,##0", "en_US").format(double.parse(orderItems.unitPrice).toInt())}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FunctionHelper.fontTheme(
                            color: ThemeColor.colorSale(),
                            fontWeight: FontWeight.w500,
                            fontSize: SizeUtil.titleFontSize().sp),
                      ),
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

  Widget paymentInfo({BuildContext context, OrderData orderData}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          // CachedNetworkImage(
          //   height: 30,
          //   placeholder: (context, url) => Container(
          //     color: Colors.white,
          //     child:
          //     Lottie.asset('assets/json/loading.json', height: 30),
          //   ),
          //   fit: BoxFit.cover,
          //   imageUrl: "https://img.utdstc.com/icons/scb-easy-android.png:225",
          //   errorWidget: (context, url, error) => Container(
          //       height: 30,
          //       child: Icon(
          //         Icons.error,
          //         size: 30,
          //       )),
          // ),
          Icon(Icons.money),
          SizedBox(
            width: 10,
          ),
          Text(orderData.paymentMethod.name,
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget timelineOrder({BuildContext context, OrderData orderData}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_order_num.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                orderData.orderNumber != null ? orderData.orderNumber : '-',
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    color: ThemeColor.colorSale(),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_buy_time.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                "${orderData.createdAt != null ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.createdAt)) : '-'}",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_pay_time.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                "${orderData.paymentAt != null ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.paymentAt)) : '-'}",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_ship_time.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                "${orderData.shippingDate != null ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.shippingDate)) : '-'}",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.order_detail_complete_time.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                "${orderData.deliveryDate != null ? DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(orderData.deliveryDate)) : '-'}",
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
            ],
          ),
          SizedBox(
            height: 13,
          ),
        ],
      ),
    );
  }

  Widget buttonConfirmPay(
      {BuildContext context,
      OrderData orderData,
      OrderViewType orderViewType}) {
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
                  // FunctionHelper.ConfirmDialog(context,
                  //     message:
                  //         "You want to cancel the order. Please note your cancellation request must be accepted by the buyer. Because the order is already in progress ",
                  //     onCancel: () {
                  //   Navigator.of(context).pop();
                  // }, onClick: () {
                  //   Navigator.of(context).pop();
                  //   AppRoute.SellerCanceled(
                  //       context: context,
                  //       orderData: widget.orderData,
                  //       typeView: orderViewType);
                  // });
                  AppRoute.sellerCanceled(
                      context: context,
                      orderData: widget.orderData,
                      typeView: orderViewType);
                },
                child: Text(
                  LocaleKeys.order_detail_cancel_order.tr(),
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
                  onPressed: () async {
                    final result = await AppRoute.confirmPayment(
                        context: context, orderData: orderData);

                    if (result) {
                      //bloc.onLoad.add(true);
                      bloc.orderDataList.clear();
                      Usermanager().getUser().then((value) => bloc.loadOrder(
                          context,
                          load: true,
                          orderType: widget.typeView == OrderViewType.Shop
                              ? "myshop/orders"
                              : "order",
                          sort: "orders.createdAt:desc",
                          statusId: "1",
                          limit: 20,
                          page: 1,
                          token: value.token));
                    }
                  },
                  child: Text(
                    LocaleKeys.order_detail_confirm_pay.tr(),
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

  Widget buttonCancel(
      {BuildContext context,
      OrderData orderData,
      OrderViewType orderViewType}) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(1.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
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
                      message: LocaleKeys.dialog_message_confirm_cancel_buyer
                          .tr(), onCancel: () {
                    Navigator.of(context).pop();
                  }, onClick: () {
                    Navigator.of(context).pop();
                    //AppRoute.SellerCanceled(context: context,orderData: widget.orderData,typeView: orderViewType);
                    Usermanager().getUser().then((value) {
                      bloc.orderCancel(context,
                          token: value.token, orderId: orderData.id);
                    });
                  });
                },
                child: Text(
                  LocaleKeys.order_detail_cancel_order.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonAcceptProducts({BuildContext context, OrderData orderData}) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(1.5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(1.0.h),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size(Device.get().isPhone ? 60.0.w : 40.0.w, 6.0.h),
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
                      message: LocaleKeys.dialog_message_confirm_order.tr(),
                      onCancel: () {
                    Navigator.of(context).pop();
                  }, onClick: () {
                    Navigator.of(context).pop();
                    Usermanager().getUser().then((value) {
                      bloc.goodsReceived(context,
                          orderId: orderData.id, token: value.token);
                    });
                    //  AppRoute.SellerCanceled(context: context,orderData: widget.orderData,typeView: orderViewType);
                  });
                },
                child: Text(
                  LocaleKeys.order_detail_accept.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonSuccess({BuildContext context, OrderData item}) {
    return Container(
      height: 8.0.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0),
            bottom: BorderSide(color: Colors.grey.withOpacity(0.4), width: 0)),
      ),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/png/star_entry.png',
                  width: 8.0.w,
                  height: 8.0.w,
                  color: Colors.grey.shade300,
                ),
                SizedBox(width: 2.0.w),
                Text(
                  LocaleKeys.btn_review.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.grey.shade300,
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            onTap: () {
              // AppRoute.review(context);
              //FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
              //Share.share('${Env.value.baseUrlWeb}/${bloc.ProductItem.value.name}-i.${bloc.ProductItem.value.id}');
              //FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
            },
          )),
          Container(
            color: Colors.grey.withOpacity(0.4),
            height: 8.0.h,
            width: 1,
          ),
          Expanded(
              flex: 2,
              child: InkWell(
                  onTap: () {
                    List<Items> items = <Items>[];
                    for (var value in bloc.orderList.value.items) {
                      items.add(Items(
                          inventoryId: value.inventoryId,
                          quantity: value.quantity));
                    }

                    Usermanager()
                        .getUser()
                        .then((value) => productBloc.addCartlists(context,
                            cartRequest: CartRequest(
                              shopId: bloc.orderList.value.shop.id,
                              items: items,
                            ),
                            token: value.token));
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 8.0.h,
                      color: ThemeColor.colorSale(),
                      child: Text(LocaleKeys.btn_buy_product_again.tr(),
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))))
        ],
      ),
    );
  }

  Widget buttonShipping({BuildContext context, OrderData orderData}) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(1.5.w),
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
                Size(50.0.w, 5.0.h),
              ),
              backgroundColor: MaterialStateProperty.all(
                ThemeColor.colorSale(),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () async {
              //AppRoute.ShippingOrder(context: context,orderData: orderData);
              final result = await AppRoute.addtTrackingNumber(
                  context: context, orderData: orderData);
              if (result) {
                Navigator.pop(context, true);
              }
            },
            child: Text(
              LocaleKeys.order_detail_ship.tr(),
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

  int sumTotal(List<OrderItems> items) {
    var sum = 0;
    for (var item in items) {
      sum += (item.inventory.offerPrice != null
              ? item.inventory.offerPrice
              : item.inventory.salePrice) *
          item.quantity;
    }
    return sum;
  }
}

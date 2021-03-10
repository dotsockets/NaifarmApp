import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class RefundView extends StatefulWidget {
  final OrderViewType typeView;

  const RefundView({Key key, this.typeView}) : super(key: key);
  @override
  _RefundViewState createState() => _RefundViewState();
}

class _RefundViewState extends State<RefundView> {
  OrdersBloc bloc;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  bool step_page = false;
  int limit = 10;

  init() {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      Usermanager().getUser().then((value) => bloc.loadOrder(context,
          orderType:
              widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
          sort: "orders.updatedAt:desc",
          statusId: "7",
          limit: 10,
          page: 1,
          token: value.token));
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (step_page) {
          step_page = false;
          page++;
          _reloadData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: StreamBuilder(
          stream: bloc.feedList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                (snapshot.data as OrderRespone).data.length > 0) {
              step_page = true;
              return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(children: [
                    Column(
                        children: (snapshot.data as OrderRespone)
                            .data
                            .asMap()
                            .map((key, value) => MapEntry(
                                key,
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        _BuildCard(
                                            item: value,
                                            index: key,
                                            context: context),
                                        value.items[0].inventory == null
                                            ? Center(
                                                child: Container(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  height: 27.0.h,
                                                  child: Center(
                                                    child: Container(
                                                      width: 30.0.w,
                                                      height: 5.0.h,
                                                      padding:
                                                          EdgeInsets.all(2.0.w),
                                                      decoration: new BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .all(
                                                                  Radius.circular(
                                                                      10.0.w))),
                                                      child: Center(
                                                        child: Text(
                                                            LocaleKeys
                                                                .search_product_not_found
                                                                .tr(),
                                                            style: FunctionHelper
                                                                .FontTheme(
                                                                    fontSize:
                                                                        SizeUtil.titleSmallFontSize()
                                                                            .sp,
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                    Container(
                                      height: 10,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                )))
                            .values
                            .toList()),
                    if ((snapshot.data as OrderRespone).data.length !=
                        (snapshot.data as OrderRespone).total)
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
                                style: FunctionHelper.FontTheme(
                                    color: Colors.grey,
                                    fontSize: SizeUtil.priceFontSize().sp))
                          ],
                        ),
                      ),
                  ]));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
              );
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
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget _BuildCard({OrderData item, BuildContext context, int index}) {
    return InkWell(
      child: Container(
        child: Column(
          children: [
            _OwnShop(item: item),
            _ProductDetail(item: item, index: index),
          ],
        ),
      ),
      onTap: () {
        // AppRoute.ProductDetail(context, productImage: "history_${index}");
        if (item.items[0].inventory != null) {
          AppRoute.OrderDetail(context,
              orderData: item, typeView: widget.typeView);
        }
      },
    );
  }

  Widget _ProductItem({OrderItems item, int shopId, int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          child: Hero(
            tag: "history_paid_${item.orderId}${item.inventoryId}${index}",
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1))),
              child: CachedNetworkImage(
                width: 22.0.w,
                height: 22.0.w,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Lottie.asset('assets/json/loading.json', height: 30),
                ),
                fit: BoxFit.cover,
                imageUrl:
                    "${Env.value.baseUrl}/storage/images/${item.inventory != null ? item.inventory.product.image.isNotEmpty ? item.inventory.product.image[0].path : '' : ''}",
                errorWidget: (context, url, error) => Container(
                    height: 22.0.w,
                    width: 22.0.w,
                    child: Icon(
                      Icons.error,
                      size: 7.0.w,
                    )),
              ),
            ),
          ),
          onTap: () {
            ProductData product = ProductData();
            product = item.inventory.product;
            product.shop = ProductShop(id: shopId);
            AppRoute.ProductDetail(context,
                productImage:
                    "history_paid_${item.orderId}${item.inventoryId}${index}",
                productItem: ProductBloc.ConvertDataToProduct(data: product));
          },
        ),
        SizedBox(width: 2.0.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.0.w),
              Container(
                child: Text(
                    item.inventory != null
                        ? item.inventory.title
                        : 'ไม่พบข้อมูล',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 6.0.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("x ${item.quantity}",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: Colors.black)),
                  Row(
                    children: [
                      item.inventory != null &&
                              item.inventory.product.discountPercent != 0
                          ? Text(
                          "฿${NumberFormat("#,##0", "en_US").format(item.inventory!=null?item.inventory.product.discountPercent:0)}",
                        //  "฿${item.inventory!=null?item.inventory.product.discountPercent:0}",
                          style: FunctionHelper.FontTheme(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: SizeUtil.titleFontSize().sp,
                              decoration: TextDecoration.lineThrough))
                          : SizedBox(),
                      SizedBox(width: 3.0.w),
                      Text(
                          "฿${NumberFormat("#,##0", "en_US").format(item.inventory != null ? item.inventory.salePrice : 999)}",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              color: ThemeColor.ColorSale()))
                    ],
                  )
                ],
              ),
              Divider(
                color: Colors.black.withOpacity(0.3),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _ProductDetail({OrderData item, int index}) {
    return Container(
      padding: EdgeInsets.all(3.0.w),
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: item.items
                .asMap()
                .map((key, value) => MapEntry(
                    key,
                    _ProductItem(
                        item: item.items[key],
                        shopId: item.shop.id,
                        index: key)))
                .values
                .toList(),
          ),
          Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: new TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      new TextSpan(
                          text: LocaleKeys.history_order_price.tr(),
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                      new TextSpan(
                          text: " : " +
                               "฿${NumberFormat("#,##0", "en_US").format(item.grandTotal)}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: ThemeColor.ColorSale())),
                          //     "฿${item.grandTotal}",
                          // style: FunctionHelper.FontTheme(
                          //     fontSize: SizeUtil.titleFontSize().sp,
                          //     color: ThemeColor.ColorSale())),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              widget.typeView == OrderViewType.Shop
                  ? _IntroShipment(address: item.shippingAddress)
                  : SizedBox(),
              widget.typeView == OrderViewType.Shop
                  ? Divider(
                      color: Colors.grey.shade400,
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.typeView == OrderViewType.Purchase
                        ? LocaleKeys.order_detail_pay_date.tr() +
                            "  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.createdAt))}"
                        : LocaleKeys.history_order_time.tr() +
                            "  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.requirePaymentAt))}",
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        color: Colors.black.withOpacity(0.6)),
                  ),
                  _BuildButtonBayItem(
                      btnTxt: widget.typeView == "shop"
                          ? "Confirm payment"
                          : "Payment",
                      item: item)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _OwnShop({OrderData item}) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 5, right: 20),
      color: Colors.white,
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.typeView == "shop"
                ? Container(
                    child: Text(
                        LocaleKeys.order_detail_id.tr() +
                            " " +
                            item.orderNumber,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.w500)),
                  )
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: CachedNetworkImage(
                          width: 7.0.w,
                          height: 7.0.w,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child: Lottie.asset(
                              'assets/json/loading.json',
                              width: 7.0.w,
                              height: 7.0.w,
                            ),
                          ),
                          fit: BoxFit.cover,
                          imageUrl:
                              "${Env.value.baseUrl}/storage/images/${item.shop.image.isNotEmpty ? item.shop.image[0].path : ''}",
                          errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade400,
                              width: 7.0.w,
                              height: 7.0.w,
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(item.shop.name,
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
            Text(
              item.orderStatusName,
              style: FunctionHelper.FontTheme(
                  color: ThemeColor.primaryColor(),
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        onTap: () {
          AppRoute.ShopMain(
              context: context, myShopRespone: MyShopRespone(id: item.shop.id));
        },
      ),
    );
  }

  Widget _BuildButtonBayItem({String btnTxt, OrderData item}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          ThemeColor.ColorSale(),
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () async {
        if (widget.typeView == "shop") {
          final result =
              await AppRoute.ConfirmPayment(context: context, orderData: item);
          if (result) {
            Usermanager().getUser().then((value) => bloc.loadOrder(context,
                orderType: widget.typeView == OrderViewType.Shop
                    ? "myshop/orders"
                    : "order",
                sort: "orders.updatedAt:desc",
                statusId: "1",
                limit: 20,
                page: 1,
                token: value.token));
          }
        } else {
          AppRoute.TransferPayMentView(context: context, orderData: item);
        }
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _IntroShipment({String address}) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/svg/delivery.svg',
            width: 4.0.h,
            height: 4.0.h,
          ),
          SizedBox(width: 2.0.w),
          Expanded(
            child: Text(address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: ThemeColor.secondaryColor())),
          ),
          Container(
              margin: EdgeInsets.only(left: 30),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 4.0.w,
              ))
        ],
      ),
    );
  }

  int SumTotal(List<OrderItems> items) {
    var sum = 0;
    for (var item in items) {
      sum += item.inventory.salePrice;
    }
    return sum;
  }

  _reloadData() {
    Usermanager().getUser().then((value) => bloc.loadOrder(context,
        orderType:
            widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
        sort: "orders.updatedAt:desc",
        statusId: "7",
        limit: 10,
        page: page,
        token: value.token));
  }

  @override
  bool get wantKeepAlive => true;
}

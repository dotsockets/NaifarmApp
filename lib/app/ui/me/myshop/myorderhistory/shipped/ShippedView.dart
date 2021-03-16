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
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ShippedView extends StatefulWidget {
  final OrderViewType typeView;

  const ShippedView({Key key, this.typeView}) : super(key: key);
  @override
  _ShippedViewState createState() => _ShippedViewState();
}

class _ShippedViewState extends State<ShippedView> {
  OrdersBloc bloc;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int limit = 10;
  bool stepPage = false;

  init() {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getHistoryCache().then((value){
        //   print("ewfcwef ${value}");
        String orderType = widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order";
        if(value!=null){
          for(var data in value.historyCache){
            if(data.orderViewType==orderType && data.TypeView=="3"){
              bloc.orderDataList.addAll(data.orderRespone.data);
              bloc.onSuccess.add(OrderRespone(data: bloc.orderDataList,total: data.orderRespone.total,limit: data.orderRespone.limit,page: data.orderRespone.limit));
              break;
            }
          }
        }
        Usermanager().getUser().then((value) => bloc.loadOrder(context,
            orderType:
            widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
            statusId: "3",
            sort: "orders.updatedAt:desc",
            limit: limit,
            page: 1,
            token: value.token));
      });


    }
    bloc.onLoad.stream.listen((event) {
      if (event) {
        FunctionHelper.showDialogProcess(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
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
                                        buildCard(
                                            item: value,
                                            index: key,
                                            context: context),
                                        value.items[0].inventory == null
                                            ? Center(
                                                child: InkWell(
                                                  child: Container(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    height: 30.0.h,
                                                    child: Center(
                                                      child: Container(
                                                        width: 30.0.w,
                                                        height: 5.0.h,
                                                        padding: EdgeInsets.all(
                                                            2.0.w),
                                                        decoration: new BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
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
                                                              style: FunctionHelper.fontTheme(
                                                                  fontSize:
                                                                      SizeUtil.titleSmallFontSize()
                                                                          .sp,
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    AppRoute.orderDetail(
                                                        context,
                                                        orderData: value,
                                                        typeView:
                                                            widget.typeView);
                                                  },
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
                                style: FunctionHelper.fontTheme(
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
                        style: FunctionHelper.fontTheme(
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

  Widget buildCard({OrderData item, BuildContext context, int index}) {
    return InkWell(
      child: Container(
        child: Column(
          children: [
            ownShop(item: item),
            productDetail(item: item, index: index),
          ],
        ),
      ),
      onTap: () async {
        // AppRoute.ProductDetail(context, productImage: "history_${index}");
        if (item.items[0].inventory != null) {
          final result = await AppRoute.orderDetail(context,
              orderData: item, typeView: widget.typeView);
          if (result) {
            bloc.orderDataList.clear();
            Usermanager().getUser().then((value) => bloc.loadOrder(context,
                load: true,
                orderType: widget.typeView == OrderViewType.Shop
                    ? "myshop/orders"
                    : "order",
                statusId: "3",
                sort: "orders.updatedAt:desc",
                limit: limit,
                page: 1,
                token: value.token));
          }
        }
      },
    );
  }

  Widget productItem(
      {OrderData orderData,
      OrderItems item,
      int shopId,
      int index,
      int idOrder}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          child: Hero(
            tag:
                "history_ship_$idOrder${item.orderId}${item.inventoryId}${index}2",
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
                    "${Env.value.baseUrl}/storage/images/${item.inventory != null ? item.inventory.product.image.isNotEmpty ? item.inventory.product.image[0].path : Env.value.noItemUrl : Env.value.noItemUrl}",
                errorWidget: (context, url, error) => Container(
                    height: 22.0.w,
                    width: 22.0.w,
                    child: Image.network(Env.value.noItemUrl)),
              ),
            ),
          ),
          onTap: () {
            ProductData product = ProductData();
            product = item.inventory.product;
            product.shop = ProductShop(id: shopId);
            AppRoute.productDetail(context,
                productImage:
                    "history_ship_$idOrder${item.orderId}${item.inventoryId}${index}2",
                productItem: ProductBloc.convertDataToProduct(data: product));
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
                        : item.itemTitle.isNotEmpty?item.itemTitle:'${LocaleKeys.search_product_not_found.tr()}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 6.0.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("x ${item.quantity}",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: Colors.black)),
                  Row(
                    children: [
                      //   item.ProductDicount != 0 ?
                      item.inventory.salePrice != null && item.inventory.offerPrice != null && item.inventory.offerPrice>0
                          ? Text(
                          "฿${NumberFormat("#,##0", "en_US").format(item.inventory.salePrice)}",
                          style: FunctionHelper.fontTheme(
                              color: Colors.grey,
                              fontSize: SizeUtil.titleFontSize().sp,
                              decoration: TextDecoration.lineThrough))
                          : SizedBox(),
                      SizedBox(
                          width: item.inventory.salePrice != null && item.inventory.offerPrice != null
                              ? 1.0.w
                              : 0),
                      Text(
                        item.inventory.offerPrice != null  && item.inventory.offerPrice !=0
                            ? "฿${NumberFormat("#,##0", "en_US").format(item.inventory.offerPrice)}"
                            : "฿${NumberFormat("#,##0", "en_US").format(item.inventory.salePrice)}",
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

  Widget productDetail({OrderData item, int index}) {
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
                    productItem(
                        orderData: item,
                        item: item.items[key],
                        shopId: item.shop.id,
                        idOrder: item.id,
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
                          text: LocaleKeys.history_order_price.tr() + " : ",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                      new TextSpan(
                          text:
                              "฿${NumberFormat("#,##0", "en_US").format(bloc.sumTotal(item.items, item.shipping != null ? item.shipping : 0))}",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              color: ThemeColor.colorSale())),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              widget.typeView == OrderViewType.Shop
                  ? introShipment(address: item.shippingAddress)
                  : SizedBox(),
              widget.typeView == OrderViewType.Shop
                  ? Divider(
                      color: Colors.grey.shade400,
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      constraints: BoxConstraints(maxWidth: (50.0.w - 12.0)),
                      child: Text(
                        widget.typeView == OrderViewType.Purchase
                            ? LocaleKeys.order_detail_ship_date.tr() +
                                "\n" +
                                LocaleKeys.order_detail_by_date.tr() +
                                " ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.createdAt))}"
                            : LocaleKeys.history_order_time.tr() +
                                "  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.createdAt))}",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.black.withOpacity(0.6)),
                      )),
                  Container(
                      constraints: BoxConstraints(maxWidth: (50.0.w - 12.0)),
                      child: buildButtonBayItem(
                          btnTxt: widget.typeView == OrderViewType.Purchase
                              ? LocaleKeys.order_detail_contact.tr()
                              : LocaleKeys.order_detail_ship.tr(),
                          item: item)) // ผู้ขายกำลังเตรียมจัดส่งสินค้า for thai
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget ownShop({OrderData item}) {
    return Container(
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 5, right: 20),
      color: Colors.white,
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.typeView == OrderViewType.Shop
                ? Container(
                    child: Text(
                        LocaleKeys.order_detail_id.tr() +
                            " " +
                            item.orderNumber,
                        style: FunctionHelper.fontTheme(
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
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
            Text(
              item.orderStatusName,
              style: FunctionHelper.fontTheme(
                  color: ThemeColor.primaryColor(),
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        onTap: () {
          AppRoute.shopMain(
              context: context, myShopRespone: MyShopRespone(id: item.shop.id));
        },
      ),
    );
  }

  Widget buildButtonBayItem({String btnTxt, OrderData item}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        padding: MaterialStateProperty.all(
            EdgeInsets.only(right: 10.0.w, left: 10.0.w)),
        backgroundColor: MaterialStateProperty.all(
          ThemeColor.colorSale(),
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () async {
        if (widget.typeView == OrderViewType.Shop) {
          // AppRoute.ShippingOrder(context: context,orderData: item);
          final result = await AppRoute.addtTrackingNumber(
              context: context, orderData: item);
          if (result) {
            bloc.orderDataList.clear();
            Usermanager().getUser().then((value) => bloc.loadOrder(context,
                load: true,
                orderType: widget.typeView == OrderViewType.Shop
                    ? "myshop/orders"
                    : "order",
                sort: "orders.updatedAt:desc",
                statusId: "3",
                limit: limit,
                page: 1,
                token: value.token));
          }
        } else {
          // AppRoute.TransferPayMentView(context: context,orderData: item);
        }
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget introShipment({String address}) {
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
                style: FunctionHelper.fontTheme(
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

  _reloadData() {
    Usermanager().getUser().then((value) => bloc.loadOrder(context,
        orderType:
            widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
        sort: "orders.updatedAt:desc",
        statusId: "3",
        limit: limit,
        page: page,
        token: value.token));
  }

  bool get wantKeepAlive => true;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

import '../SizeUtil.dart';
import 'NaifarmErrorWidget.dart';

class HistoryProductCard extends StatelessWidget {
  final OrderData order;
  final Widget buttomAction;
  final OrderViewType type;
  final String pageVeiw;
  const HistoryProductCard(
      {Key key, this.order, this.buttomAction, this.type, this.pageVeiw})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 15, top: 15, bottom: 5, right: 20),
                  color: Colors.white,
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        this.type == OrderViewType.Shop
                            ? Container(
                                child: Text(
                                  LocaleKeys.order_detail_id.tr() +
                                      " " +
                                      this.order.orderNumber,
                                  style: FunctionHelper.fontTheme(
                                      fontSize:
                                          SizeUtil.titleSmallFontSize().sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        SizeUtil.borderRadiusShop(),
                                      ),
                                    ),
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
                                          "${Env.value.baseUrl}/storage/images/${this.order.shop.image.isNotEmpty ? this.order.shop.image[0].path : ''}",
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey.shade400,
                                        width: 7.0.w,
                                        height: 7.0.w,
                                        child: Icon(
                                          Icons.person,
                                          size: 5.0.w,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    this.order.shop.name,
                                    style: FunctionHelper.fontTheme(
                                        fontSize:
                                            SizeUtil.titleSmallFontSize().sp,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                        Text(
                          this.order.image != null &&
                                  this.order.image.isNotEmpty
                              ? this.order.orderStatusName
                              : this.order.orderStatusName,
                          style: FunctionHelper.fontTheme(
                              color: ThemeColor.primaryColor(),
                              fontSize: SizeUtil.titleSmallFontSize().sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    onTap: () {
                      AppRoute.shopMain(
                        context: context,
                        myShopRespone: MyShopRespone(id: this.order.shop.id),
                      );
                    },
                  ),
                ),
                // Product detail
                Container(
                  padding: EdgeInsets.all(3.0.w),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Column(
                        children: this
                            .order
                            .items
                            .asMap()
                            .map(
                              (key, value) => MapEntry(
                                key,
                                productItem(
                                    orderData: this.order,
                                    item: value,
                                    shopId: this.order.shop.id,
                                    idOrder: this.order.id,
                                    index: key,
                                    context: context),
                              ),
                            )
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
                                    text:
                                        LocaleKeys.cart_sub_total.tr() + " : ",
                                    style: FunctionHelper.fontTheme(
                                        fontSize:
                                            SizeUtil.spanTitleFontSize().sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  new TextSpan(
                                    text:
                                        "฿${NumberFormat("#,##0", "en_US").format(this.order.grandTotal != null ? this.order.grandTotal : 0)}",
                                    style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.spanTitleFontSize().sp,
                                      color: ThemeColor.colorSale(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade400,
                          ),
                          this.type == OrderViewType.Shop
                              ? introShipment(
                                  address: this.order.shippingAddress)
                              : SizedBox(),
                          this.type == OrderViewType.Shop
                              ? Divider(
                                  color: Colors.grey.shade400,
                                )
                              : SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                this.type == OrderViewType.Purchase
                                    ? this.order.paymentStatus == 1
                                        ? "${LocaleKeys.order_detail_pay_date.tr()} ${DateFormat('dd-MM-yyyy').format(DateTime.parse(this.order.requirePaymentAt))}"
                                        : "${LocaleKeys.order_detail_upload_slip.tr()} ${DateFormat('dd-MM-yyyy').format(DateTime.parse(this.order.requestPaymentAt ?? DateTime.now().toString()))}"
                                    : LocaleKeys.history_order_time.tr() +
                                        " " +
                                        " ${DateFormat('dd-MM-yyyy').format(DateTime.parse(this.order.createdAt))}",
                                style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              this.buttomAction,
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () => {
            AppRoute.orderDetail(context,
                orderData: this.order, typeView: this.type)
          },
        ),
        this.order.items[0].inventory == null
            ? Positioned.fill(
                child: InkWell(
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Center(
                      child: Container(
                        width: 30.0.w,
                        height: 5.0.h,
                        padding: EdgeInsets.all(2.0.w),
                        decoration: new BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10.0.w))),
                        child: Center(
                          child: Text(
                              LocaleKeys.search_product_product_not_found.tr(),
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    AppRoute.orderDetail(context,
                        orderData: this.order, typeView: this.type);
                  },
                ),
              )
            : SizedBox()
      ],
    );
  }

  Widget productItem(
      {OrderData orderData,
      OrderItems item,
      int shopId,
      int index,
      int idOrder,
      BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          child: Hero(
            tag: "history_" +
                this.pageVeiw +
                "_$idOrder${item.inventoryId}${index}1",
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
              child: CachedNetworkImage(
                width: 22.0.w,
                height: 22.0.w,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Lottie.asset('assets/json/loading.json', height: 30),
                ),
                fit: BoxFit.cover,
                imageUrl: item.itemImagePath != null
                    ? "${Env.value.baseUrl}/storage/images/${item.itemImagePath}"
                    : Env.value.noItemUrl,
                errorWidget: (context, url, error) => Container(
                  height: 22.0.w,
                  width: 22.0.w,
                  child: NaifarmErrorWidget(),
                ),
              ),
            ),
          ),
          onTap: () {
            ProductData product = ProductData();
            product = item.inventory.product;
            product.shop = ProductShop(id: shopId);
            AppRoute.productDetail(
              context,
              productImage: "history_" +
                  this.pageVeiw +
                  "_$idOrder${item.inventoryId}${index}1",
              productItem: ProductBloc.convertDataToProduct(data: product),
            );
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
                      : item.itemTitle.isNotEmpty
                          ? item.itemTitle
                          : LocaleKeys.search_product_not_found.tr(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w600),
                ),
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
                      item.unitPrice != null &&
                              item.offerPrice != null &&
                              double.parse(item.offerPrice.toString()) > 0
                          ? Text(
                              "฿${NumberFormat("#,##0", "en_US").format(double.parse(item.unitPrice))}",
                              style: FunctionHelper.fontTheme(
                                  color: Colors.grey,
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  decoration: TextDecoration.lineThrough),
                            )
                          : SizedBox(),
                      SizedBox(
                          width:
                              item.unitPrice != null && item.offerPrice != null
                                  ? 1.0.w
                                  : 0),
                      Text(
                        item.offerPrice != null &&
                                double.parse(item.offerPrice.toString()) != 0
                            ? "฿${NumberFormat("#,##0", "en_US").format(double.parse(item.offerPrice.toString()))}"
                            : "฿${NumberFormat("#,##0", "en_US").format(double.parse(item.unitPrice).toInt())}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FunctionHelper.fontTheme(
                            color: ThemeColor.colorSale(),
                            fontWeight: FontWeight.w500,
                            fontSize: SizeUtil.titleFontSize().sp),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget introShipment({String address}) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Image.asset(
            'assets/images/png/delivery.png',
            width: 4.0.h,
            height: 4.0.h,
          ),
          SizedBox(width: 2.0.w),
          Expanded(
            child: Text(
              address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: ThemeColor.secondaryColor(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: SizeUtil.ratingSize().w,
            ),
          ),
        ],
      ),
    );
  }
}

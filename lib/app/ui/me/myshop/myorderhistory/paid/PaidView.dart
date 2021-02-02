import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/OrderBloc.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:sizer/sizer.dart';

import 'package:provider/provider.dart';

class PaidView extends StatefulWidget {
  final String orderType;

  const PaidView({Key key, this.orderType}) : super(key: key);
  @override
  _PaidViewState createState() => _PaidViewState();
}

class _PaidViewState extends State<PaidView> with AutomaticKeepAliveClientMixin<PaidView> {
  OrdersBloc bloc;

  init() {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      Usermanager().getUser().then((value) =>
          bloc.loadOrder(orderType: widget.orderType,statusId: 1, limit: 20, page: 1, token: value.token));
    }
    // Usermanager().getUser().then((value) => context.read<OrderBloc>().loadOrder(statusId: 1, limit: 20, page: 1, token: value.token));
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),

      child:  StreamBuilder(
          stream: bloc.feedList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && (snapshot.data as OrderRespone).data.length>0) {
              return SingleChildScrollView(
                child: Column(
                    children: (snapshot.data as OrderRespone)
                        .data
                        .asMap()
                        .map((key, value) => MapEntry(
                        key,
                          Column(
                            children: [
                              _BuildCard(
                                  item: value, index: key, context: context),
                              Container(height: 10,color: Colors.grey.shade300,)
                            ],
                          )
                      ))
                        .values
                        .toList()),
              );
            } else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child:  Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator(),);
            }else {
              return Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 15.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/boxorder.json',
                          height: 70.0.w, width: 70.0.w, repeat: false),
                      Text(
                        LocaleKeys.cart_empty.tr(),
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
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
        AppRoute.OrderDetail(context,item.orderStatusId,orderData: item);
      },
    );
  }

  Widget _ProductItem({OrderItems item,int shopId, int index}) {
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
                  child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                ),
                fit: BoxFit.cover,
                imageUrl:
                    "${Env.value.baseUrl}/storage/images/${item.inventory.product.image.isNotEmpty ? item.inventory.product.image[0].path : ''}",
                errorWidget: (context, url, error) => Container(
                    height: 30,
                    child: Icon(
                      Icons.error,
                      size: 30,
                    )),
              ),
            ),
          ),
          onTap: (){
            var product = item.inventory.product;
            product.salePrice = item.inventory.salePrice;
            product.saleCount = item.inventory.product.saleCount;
            product.shop = ProductShop(id: shopId);
            AppRoute.ProductDetail(context, productImage: "history_paid_${item.orderId}${item.inventoryId}${index}",productItem: ProductBloc.ConvertDataToProduct(data: product));
          },
        ),
        SizedBox(width: 2.0.w),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.0.w),
              Container(
                child: Text(item.inventory.title,
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
                      item.inventory.product.discountPercent != 0
                          ? Text(
                              "฿${NumberFormat("#,##0.00", "en_US").format(item.inventory.product.discountPercent)}",
                              style: FunctionHelper.FontTheme(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  decoration: TextDecoration.lineThrough))
                          : SizedBox(),
                      SizedBox(width: 3.0.w),
                      Text(
                          "฿${NumberFormat("#,##0.00", "en_US").format(item.inventory.salePrice)}",
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
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
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
                    key, _ProductItem(item: item.items[key],shopId: item.shop.id, index: key)))
                .values
                .toList(),
          ),
          SizedBox(height: 3.0.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.5.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("x ${item.quantity}",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          color: Colors.black)),
                  Row(
                    children: [
                      Text(
                          LocaleKeys.history_order_price.tr() +
                              " : " +
                              "${NumberFormat("#,##0.00", "en_US").format(SumTotal(item.items))}",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              color: Colors.black)),
                      // Text(
                      //     "฿${item.inventory.salePrice * item.quantity}.00",
                      //     style: FunctionHelper.FontTheme(
                      //         fontSize: SizeUtil.titleFontSize().sp,
                      //         color: ThemeColor.ColorSale())),
                      SizedBox(width: 2.0.w),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _IntroShipment(address: item.shippingAddress),
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
              Divider(
                color: Colors.grey.shade400,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.history_order_time.tr() +
                        "  ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.requirePaymentAt))}",
                    style: FunctionHelper.FontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        color: Colors.black.withOpacity(0.6)),
                  ),
                  _BuildButtonBayItem(btnTxt: "Payment")
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
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    width: 7.0.w,
                    height: 7.0.w,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: Lottie.asset(
                        Env.value.loadingAnimaion,
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
        onTap: (){
          AppRoute.ShopMain(context: context,myShopRespone: MyShopRespone(id: item.shop.id));
        },
      ),
    );
  }

  Widget _BuildButtonBayItem({String btnTxt}) {
    return FlatButton(
      color: ThemeColor.ColorSale(),
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {},
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(
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
          Text(address,
              overflow: TextOverflow.ellipsis,
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: ThemeColor.secondaryColor())),
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

  @override
  bool get wantKeepAlive => true;
}

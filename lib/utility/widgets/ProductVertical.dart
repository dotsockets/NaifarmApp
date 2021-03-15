import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'ProductLandscape.dart';

// ignore: must_be_immutable
class ProductVertical extends StatelessWidget {
  final String titleInto;
  final Function() onSelectMore;
  final Function(ProductData, int) onTapItem;
  final Function(ProductData, int) onTapBay;
  final String iconInto;
  final String imageIcon;
  final bool borderRadius;
  final String tagHero;
  final double iconSize;
  final ProductRespone productRespone;

  ProductVertical(
      {Key key,
      this.titleInto,
      this.onSelectMore,
      this.onTapItem,
      this.iconInto,
      this.imageIcon = "",
      this.borderRadius,
      this.tagHero,
      this.iconSize = 35,
      this.productRespone,
      this.onTapBay})
      : super(key: key);

  ProductBloc productBloc;

  init(BuildContext context) {
    if (productBloc == null) {
      productBloc = ProductBloc(AppProvider.getApplication(context));
      productBloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      productBloc.onError.stream.listen((event) {
        if (event != null) {
          FunctionHelper.alertDialogShop(context,
              title: LocaleKeys.btn_error.tr(), message: event.message);
        }
      });

      productBloc.productItem.stream.listen((event) {
        List<Items> items = [];
        items.add(Items(inventoryId: event.inventories[0].id, quantity: 1));

        Usermanager()
            .getUser()
            .then((value) => productBloc.addCartlists(context,
                addNow: false,
                onload: false,
                cartRequest: CartRequest(
                  shopId: event.shopId,
                  items: items,
                ),
                token: value.token));
      });
      productBloc.onSuccess.stream.listen((event) {
        //onUpload = true;
        if (event is CartResponse) {
          AppRoute.myCart(context, true, cartNowId: productBloc.bayNow);
          // Usermanager().getUser().then((value) => bloc.GetMyWishlistsById(token: value.token,productId: widget.productItem.id));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius ? 40 : 0),
          topRight: Radius.circular(borderRadius ? 40 : 0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: new BoxDecoration(
          color: Colors.white,
          // borderRadius:  IsborderRadius?BorderRadius.only(
          //   topRight: const Radius.circular(30.0),
          //   topLeft: const Radius.circular(30.0),
          // ):BorderRadius.all(Radius.circular(0.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            _headerBar(),
            productRespone != null
                ? Column(
                    children: productRespone.data
                        .asMap()
                        .map((key, value) => MapEntry(
                            key,
                            _buildCardProduct(context,
                                item: value, index: key)))
                        .values
                        .toList(),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Container _headerBar() => Container(
        margin: EdgeInsets.all(1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            imageIcon != ""
                ? Image.asset(
                    imageIcon,
                    width: iconSize,
                    height: iconSize,
                  )
                : SvgPicture.asset(
                    iconInto,
                    width: iconSize,
                    height: iconSize,
                  ),
            SizedBox(width: 2.0.w),
            Text(titleInto,
                style: FunctionHelper.fontTheme(
                    color: Colors.black,
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildCardProduct(BuildContext context,
      {ProductData item, int index}) {
    return InkWell(
      onTap: () {
        onTapItem(item, index);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade400),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Hero(
                          tag: "${tagHero}_$index",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.3.h),
                            child: CachedNetworkImage(
                              width: 28.0.w,
                              height: 35.0.w,
                              placeholder: (context, url) => Container(
                                color: Colors.white,
                                child: Lottie.asset(
                                  'assets/json/loading.json',
                                  width: 28.0.w,
                                  height: 35.0.w,
                                ),
                              ),
                              imageUrl:
                                  ProductLandscape.covertUrlImage(item.image),
                              errorWidget: (context, url, error) => Container(
                                  width: 28.0.w,
                                  height: 35.0.w,
                                  child: Image.network(Env.value.noItemUrl,
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        child: Container(
                          margin: EdgeInsets.all(1.5.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.w),
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 1.5.w,
                                  left: 1.5.w,
                                  top: 1.0.w,
                                  bottom: 1.0.w),
                              color: ThemeColor.colorSale(),
                              child: Text(
                                "${item.discountPercent}%",
                                style: FunctionHelper.fontTheme(
                                    color: Colors.white,
                                    fontSize: SizeUtil.titleSmallFontSize().sp),
                              ),
                            ),
                          ),
                        ),
                        visible: item.discountPercent > 0 ? true : false,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoProduct(item: item, context: context),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            productRespone.data.length != index
                ? Divider(color: Colors.black.withOpacity(0.3))
                : SizedBox(
                    height: 30,
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoProduct({ProductData item, BuildContext context}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(item.name,
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: FunctionHelper.fontTheme(
                    color: Colors.black,
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.normal)),
          ),
          SizedBox(
            height: 0.8.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              item.offerPrice != null
                  ? Text(
                      "฿${NumberFormat("#,##0", "en_US").format(item.salePrice)}",
                      style: FunctionHelper.fontTheme(
                          color: Colors.grey,
                          fontSize: SizeUtil.priceFontSize().sp - 1,
                          decoration: TextDecoration.lineThrough))
                  : SizedBox(),
              SizedBox(width: item.offerPrice != null ? 1.0.w : 0),
              Text(
                item.offerPrice != null
                    ? "฿${NumberFormat("#,##0", "en_US").format(item.offerPrice)}"
                    : "฿${NumberFormat("#,##0", "en_US").format(item.salePrice)}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FunctionHelper.fontTheme(
                    color: ThemeColor.colorSale(),
                    fontWeight: FontWeight.w500,
                    fontSize: SizeUtil.priceFontSize().sp),
              ),
            ],
          ),
          SizedBox(
            height: 1.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {},
                          starCount: 5,
                          rating: item.rating.toDouble(),
                          size: 4.0.w,
                          isReadOnly: true,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half_outlined,
                          color: Colors.amber,
                          borderColor: Colors.grey.shade300,
                          spacing: 0.0),
                      SizedBox(
                        width: 1.0.w,
                      ),
                      // Text("${item.rating.toDouble()}",style: FunctionHelper.fontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(height: 1.0.h),
                  Text(
                    LocaleKeys.my_product_sold.tr() +
                        " " +
                        item.saleCount.toString().replaceAll("null", "0") +
                        " " +
                        LocaleKeys.cart_piece.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: SizeUtil.detailFontSize().sp),
                  ),
                ],
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: 2.0.w),
                  padding: EdgeInsets.only(
                      right: 3.0.w, left: 3.0.w, top: 1.5.w, bottom: 1.5.w),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Text(
                    LocaleKeys.btn_buy_now.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  productBloc.getProductsById(context, id: item.id);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

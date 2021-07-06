import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:like_button/like_button.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

// ignore: must_be_immutable
class ProductInto extends StatelessWidget {
  final ProducItemRespone data;
  final DataWishlists dataWishlist;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showBtn;
  final bool isLogin;
  final Function() callbackLogin;

  ProductInto(
      {Key key,
      this.data,
      this.dataWishlist,
      this.scaffoldKey,
      this.showBtn = true,
      this.callbackLogin,
      this.isLogin})
      : super(key: key);
  ProductBloc bloc;


  void _init(BuildContext context) {
    if (null == bloc) {

      bloc = ProductBloc(AppProvider.getApplication(context));
      //bloc.ProductItem.add(widget.productItem);
      bloc.onError.stream.listen((event) {
        //checkScrollControl.add(true);
        if (event != null) {
          if (event.status == 406) {
            FunctionHelper.alertDialogShop(context,
                title: LocaleKeys.btn_error.tr(), message: event.message);
          } else if (event.status == 0 || event.status >= 500) {
          } else {
            //FunctionHelper.snackBarShow(scaffoldKey: scaffoldKey, message: event.message);
            FunctionHelper.alertDialogShop(context,
                title: LocaleKeys.btn_error.tr(), message: event.message);
          }
        }
      });

      // if (dataWishlist != null) {
      //   bloc.wishlists.add(WishlistsRespone(data: [dataWishlist], total: 1));
      // }

      bloc.isStatus.stream.listen((event) {
        if (event) {
          FunctionHelper.snackBarShow(
              context: context,
              scaffoldKey: scaffoldKey,
              message: LocaleKeys.my_product_islike.tr());
        } else {
          FunctionHelper.snackBarShow(
              context: context,
              scaffoldKey: scaffoldKey,
              message: LocaleKeys.my_product_unlike.tr());
        }
      });

    }
  }



  @override
  Widget build(BuildContext context) {
    _init(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(left: 3.0.w, right: 1.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name ?? "",
              textAlign: TextAlign.left,
              style: FunctionHelper.fontTheme(
                  fontSize: (SizeUtil.titleFontSize() + 2).sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                data.salePrice != null && data.offerPrice != null
                    ? Text(
                        "฿${data.salePrice.priceFormat()}",
                        style: FunctionHelper.fontTheme(
                            color: Colors.grey,
                            fontSize: SizeUtil.priceFontSize().sp - 2,
                            decoration: TextDecoration.lineThrough))
                    : SizedBox(),
                SizedBox(
                    width: data.salePrice != null && data.offerPrice != null
                        ? 1.0.w
                        : 0),
                Text(
                  data.offerPrice != null
                      ? "฿${data.offerPrice.priceFormat()}"
                      : "฿${data.salePrice!=null?data.salePrice.priceFormat():0}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FunctionHelper.fontTheme(
                      color: ThemeColor.colorSale(),
                      fontWeight: FontWeight.w500,
                      fontSize: SizeUtil.priceFontSize().sp),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (data.rating != null && data.rating != 0) {
                      AppRoute.reviewMore(context: context, productId: data.id);
                      print(data.rating.toDouble());
                    }
                  },
                  child: SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {},
                      starCount: 5,
                      rating: data.rating != null && data.rating != 0
                          ? data.rating.toDouble()
                          : 0.0,
                      size: SizeUtil.ratingSize().w,
                      isReadOnly: true,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half_outlined,
                      color: Colors.amber,
                      borderColor: Colors.grey.shade300,
                      spacing: 0.0),
                ),
                SizedBox(
                  width: 1.0.w,
                ),
                Text(
                    "${data.rating != null && data.rating != 0 ? data.rating.toStringAsFixed(2) : 0}",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp)),
                SizedBox(
                  width: 1.0.w,
                ),
                Center(
                  child: Container(
                    width: 1,
                    color: Colors.black.withOpacity(0.5),
                    height: 1.3.h,
                  ),
                ),
                SizedBox(
                  width: 1.0.w,
                ),
                Expanded(
                  child: Text(
                    "${LocaleKeys.my_product_sold.tr()} ${data.saleCount != null ? data.saleCount.toString() : '0'} ${LocaleKeys.cart_piece.tr()}",
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleSmallFontSize().sp),
                  ),
                ),
                InkWell(
                  child: Image.asset(
                    'assets/images/png/share.png',
                    width: SizeUtil.checkMarkSize().w,
                    height: SizeUtil.checkMarkSize().w,
                    color: showBtn
                        ? Colors.black.withOpacity(0.55)
                        : Colors.transparent,
                  ),
                  onTap: () {
                    Share.share(
                        '${Env.value.baseUrlWeb}/${data.name}-i.${data.id}');
                    //  print("rwefv ${Env.value.baseUrlWeb}/${data.name}-i.${data.id}");
                    // FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                  },
                ),
                showBtn
                    ? SizedBox(
                        width: 1.0.h,
                      )
                    : SizedBox(),
                showBtn
                    ? StreamBuilder(
                        stream: bloc.wishlists.stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshotwish) {
                          if (isLogin) {
                            // if (snapshot.hasData &&
                            //     (snapshot.data as WishlistsRespone) != null) {
                            //   if ((snapshot.data as WishlistsRespone).total >
                            //       0) {
                            //     return likeContent(
                            //         item: snapshot.data, context: context);
                            //   } else {
                            //     return likeContent(
                            //         item: snapshot.data, context: context);
                            //   }
                            // } else {
                            //   return likeContent(
                            //       item: WishlistsRespone(), context: context);
                            // }

                            return Container(
                              child: FutureBuilder<DataWishlists>(
                                  future: bloc.getWishlistsByProductFuture(context,id: data.id),
                                  // a Future<String> or null
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DataWishlists> snapshot) {

                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                        return SizedBox();
                                      case ConnectionState.waiting:
                                          return likeContent(item: WishlistsRespone(data: (snapshotwish.data as WishlistsRespone)!=null ?[DataWishlists()]:[]), context: context);

                                      default:
                                        if (snapshot.hasData && snapshot.data!=null)
                                          return likeContent(item: WishlistsRespone(data: [snapshot.data]), context: context);

                                        else
                                          return likeContent(item: WishlistsRespone(data: []), context: context);
                                    }
                                  }),
                            );
                          } else {
                            return likeContentNoLogin(context);
                          }
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 15),
            // _IntroShipment()
          ],
        ),
      ),
    );
  }

  Widget likeContentNoLogin(BuildContext context) {
    return InkWell(
      child: Container(
          margin: EdgeInsets.only(right: 2.0.w, left: 1.0.w),
          child: Icon(
            Icons.favorite_outline_sharp,
            size: 8.0.w,
            color: Colors.black.withOpacity(0.55),
          )),
      onTap: () {
        AppRoute.login(context,
            isCallBack: true,
            isHeader: true,
            isSetting: false, homeCallBack: (bool fix) {
          if (fix) {
            callbackLogin();
          }

          // iSLogin();
        });
      },
    );
  }

  Widget likeContent({WishlistsRespone item, BuildContext context}) {
    return LikeButton(
      size: 10.0.w,
      isLiked: item.data!=null && item.data.isNotEmpty  ? true : false,
      circleColor:
          const CircleColor(start: Color(0xffF03A13), end: Color(0xffE6593A)),
      bubblesColor: const BubblesColor(
        dotPrimaryColor: Color(0xffF03A13),
        dotSecondaryColor: Color(0xffE6593A),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_outline_sharp,
          color:
              isLiked ? ThemeColor.colorSale() : Colors.black.withOpacity(0.55),
          size: SizeUtil.checkMarkSize().w,
        );
      },
      likeCountAnimationType: LikeCountAnimationType.part,
      likeCountPadding: EdgeInsets.all(1.0.w),
      onTap: (bool like) =>
          onLikeButtonTapped(item.data!=null && item.data.isNotEmpty ? true : false, item, context),
    );
  }

  Future<bool> onLikeButtonTapped(
      bool isLiked, WishlistsRespone item, BuildContext context) async {
    if (item.data!=null && item.data.isNotEmpty) {

      // int id = item.data[0].id;
      // int inventoryId = item.data[0].inventoryId;
      //bloc.wishlists.add(WishlistsRespone());
     // bloc.wishlists.add(null);
      Usermanager().getUser().then((value) => bloc.deleteWishlists(context,
          productId: data.inventories[0].id, wishId: item.data[0].id, token: value.token,reload: true));
    } else {

      bloc.wishlists.add(WishlistsRespone(data: [DataWishlists()]));
      Usermanager().getUser().then((value) => bloc.addWishlists(context,
          productId: data.id,
          inventoryId: data.inventories[0].id,
          token: value.token));
    }
    return !isLiked;
  }

  Widget introShipment() {
    return Container(
      color: ThemeColor.primaryColor().withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
        child: Row(
          children: [
            Image.asset(
              'assets/images/png/delivery.png',
              width: 8.0.w,
              height: 8.0.w,
            ),
            SizedBox(width: 2.0.w),
            Text(LocaleKeys.cart_free.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: ThemeColor.colorSale())),
            Text(LocaleKeys.cart_delivery_free.tr(),
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:like_button/like_button.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

// ignore: must_be_immutable
class ProductInto extends StatelessWidget {
  final ProducItemRespone data;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showBtn;

  ProductInto({Key key, this.data, this.scaffoldKey, this.showBtn = true})
      : super(key: key);
  ProductBloc bloc;
  bool isLogin = true;

  void _init(BuildContext context) {
    if (null == bloc) {
      iSLogin();
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
            FunctionHelper.snackBarShow(
                scaffoldKey: scaffoldKey, message: event.message);
          }
        }
      });

      bloc.wishlists.stream.listen((event) {
        Usermanager().getUser().then((value) => context
            .read<CustomerCountBloc>()
            .loadCustomerCount(context, token: value.token));
      });

      Usermanager().getUser().then((value) => bloc.getWishlistsByProduct(
          context,
          token: value.token,
          productID: data.id));
    }
  }

  void iSLogin() async => isLogin = await Usermanager().isLogin();

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
              data.name.toString(),
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
                        "฿${NumberFormat("#,##0", "en_US").format(data.salePrice)}",
                        style: FunctionHelper.fontTheme(
                            color: Colors.grey,
                            fontSize: SizeUtil.priceFontSize().sp,
                            decoration: TextDecoration.lineThrough))
                    : SizedBox(),
                SizedBox(
                    width: data.salePrice != null && data.offerPrice != null
                        ? 1.0.w
                        : 0),
                Text(
                  data.offerPrice != null
                      ? "฿${NumberFormat("#,##0", "en_US").format(data.offerPrice)}"
                      : "฿${NumberFormat("#,##0", "en_US").format(data.salePrice)}",
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
                SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {},
                    starCount: 5,
                    rating: data.rating != null && data.rating != 0
                        ? data.rating.toDouble()
                        : 0.0,
                    size: 13.0,
                    isReadOnly: true,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half_outlined,
                    color: Colors.amber,
                    borderColor: Colors.grey.shade300,
                    spacing: 0.0),
                SizedBox(
                  width: 1.0.w,
                ),
                Text(
                    "${data.rating != null && data.rating != 0 ? data.rating : 0}",
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
                  child: SvgPicture.asset(
                    'assets/images/svg/share.svg',
                    width: 8.0.w,
                    height: 8.0.w,
                    color: showBtn
                        ? Colors.black.withOpacity(0.55)
                        : Colors.transparent,
                  ),
                  onTap: () {
                    Share.share(
                        '${Env.value.baseUrlWeb}/${data.name}-i.${data.id}');
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
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData &&
                              (snapshot.data as WishlistsRespone) != null) {
                            if ((snapshot.data as WishlistsRespone).total > 0) {
                              return likeContent(
                                  item: snapshot.data, context: context);
                            } else {
                              return isLogin
                                  ? likeContent(
                                      item: snapshot.data, context: context)
                                  : likeContentNoLogin(context);
                            }
                          } else {
                            return isLogin
                                ? likeContent(item: WishlistsRespone())
                                : likeContentNoLogin(context);
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
        AppRoute.login(context, isHeader: true, homeCallBack: (bool fix) {
          iSLogin();
        });
      },
    );
  }

  Widget likeContent({WishlistsRespone item, BuildContext context}) {
    return LikeButton(
      size: 10.0.w,
      isLiked: item.total > 0 ? true : false,
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
          size: 8.0.w,
        );
      },
      likeCountAnimationType: LikeCountAnimationType.part,
      likeCountPadding: EdgeInsets.all(1.0.w),
      onTap: (bool like) =>
          onLikeButtonTapped(item.total > 0 ? true : false, item, context),
    );
  }

  Future<bool> onLikeButtonTapped(
      bool isLiked, WishlistsRespone item, BuildContext context) async {
    if (item.total > 0) {
      int id = item.data[0].id;
      item.data = [];
      item.total = 0;
      bloc.wishlists.add(item);
      Usermanager().getUser().then((value) =>
          bloc.deleteWishlists(context, wishId: id, token: value.token));
    } else {
      Usermanager().getUser().then((value) => bloc.addWishlists(context,
          productId: data.id,
          inventoryId: data.inventories[0].id,
          token: value.token));
      item.data = [];
      item.total = 1;
      bloc.wishlists.add(item);
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
            SvgPicture.asset(
              'assets/images/svg/delivery.svg',
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

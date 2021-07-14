import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';
import '../SizeUtil.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ShopOwn extends StatelessWidget {
  final ShopItem shopItem;
  final MyShopRespone shopRespone;
  final bool showBtn;
  bool rateStyle = true;

  ShopOwn(
      {Key key,
      this.shopItem,
      this.shopRespone,
      this.showBtn = true,
      this.rateStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(SizeUtil.borderRadiusFooter()),
                    child: CachedNetworkImage(
                      width: SizeUtil.imgItemSize().w,
                      height: SizeUtil.imgItemSize().w,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child: Lottie.asset('assets/json/loading.json',
                            width: SizeUtil.imgItemSize().w,
                            height: SizeUtil.imgItemSize().w),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: shopItem.image!=null?shopItem.image.length != 0
                          ?
                      "${shopItem.image[0].path.imgUrl()}"
                          : "":"",
                      // errorWidget: (context, url, error) => Container(
                      //     width: SizeUtil.imgItemSize().w,
                      //     height: SizeUtil.imgItemSize().w,
                      //     child: CircleAvatar(
                      //       backgroundColor: Color(0xffE6E6E6),
                      //       radius: 30,
                      //       child: Icon(
                      //         Icons.shopping_bag_rounded,
                      //         color: Color(0xffCCCCCC),
                      //       ),
                      //  )),
                      errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade300,
                          width: SizeUtil.imgItemSize().w,
                          height: SizeUtil.imgItemSize().w,
                          child: Icon(
                            Icons.person,
                            size: (SizeUtil.iconSize() - 2).w,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  onTap: () {
                    AppRoute.imageFullScreenView(
                        heroTag: "image_profile",
                        context: context,
                        imgList:
                        shopItem.image.length!=0?
                        shopItem.image
                            .map((e) =>
                                "${e.path.imgUrl()}")
                            .toList(): [""]);
                  },
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shopItem.name != null ? shopItem.name : "Naifarm Shop",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.black,
                            height: 1,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(
                        shopItem.updatedAt != null
                            ? "Active ${timeago.format(DateTime.parse(shopItem.updatedAt.dateTimeSecFormat()), locale: 'th')}"
                            : "-",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.black.withOpacity(0.8))),
                    SizedBox(height: 2),
                    Text(
                        "${shopItem.state != null ? "จังหวัด${shopItem.state.name}" : ' -'}",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.black.withOpacity(0.8),
                            height: 1.5)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            height: 10,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.only(left: 2.5.w, right: 2.5.w, bottom: 10, top: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                          "${shopItem.countProduct != null ? shopItem.countProduct : '0'}",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.priceFontSize().sp,
                              color: ThemeColor.colorSale(),
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Text(LocaleKeys.shop_product_list.tr(),
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp))
                    ],
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(right: 2.0.w, left: 2.0.w),
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 1),
                          right: BorderSide(
                              color: Colors.grey.withOpacity(0.5), width: 1)),
                    ),
                    child: Column(
                      children: [
                        rateStyle
                            ? Text(
                                "${shopItem.rating != null && shopItem.rating != 0 ? shopItem.rating : '0'}",
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.priceFontSize().sp,
                                    color: ThemeColor.colorSale(),
                                    fontWeight: FontWeight.w500))
                            : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            rateStyle == false
                                ? Text(
                                    "${shopItem.rating != null && shopItem.rating != 0 ? shopItem.rating : '0 '}",
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.priceFontSize().sp,
                                        color: ThemeColor.colorSale(),
                                        fontWeight: FontWeight.w500))
                                : SizedBox(),
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {},
                                starCount: 5,
                                rating: shopItem.rating != null &&
                                        shopItem.rating != 0
                                    ? shopItem.rating
                                    : 0,
                                //  rating: shopItem.rating!=null&&shopItem.rating!=0?shopItem.rating.toDouble():0.0,
                                size: (SizeUtil.ratingSize() + 0.5).w,
                                isReadOnly: true,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half_outlined,
                                color: Colors.amber,
                                borderColor: Colors.grey.shade300,
                                spacing: 0.0)
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(LocaleKeys.shop_rate.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleSmallFontSize().sp)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: showBtn
                        ? Container(
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.only(
                                        left: 1.5.w,
                                        right: 1.5.w,
                                        top: 1.5.w,
                                        bottom: 1.5.w)),
                                minimumSize: MaterialStateProperty.all(
                                  Size(20.0.w, 4.0.h),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  ThemeColor.secondaryColor(),
                                ),
                                overlayColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0.3),
                                ),
                              ),
                              onPressed: () {
                                AppRoute.shopMain(
                                    context: context,
                                    myShopRespone: shopRespone);
                              },
                              child: Text(
                                LocaleKeys.shop_title.tr(),
                                style: FunctionHelper.fontTheme(
                                    color: Colors.white,
                                    fontSize: SizeUtil.titleSmallFontSize().sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 5.0.w,
                            height: 5.0.w,
                          ))

                // Expanded(
                //   flex: 1,
                //   child: Column(
                //     children: [
                //       Text("3",
                //           style: FunctionHelper.fontTheme(fontSize: SizeUtil.priceFontSize().sp,color: ThemeColor.colorSale(),fontWeight: FontWeight.bold)),
                //       SizedBox(height: 5,),
                //       Text(LocaleKeys.shop_follower.tr(),
                //           style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleSmallFontSize().sp)),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.black,
          )
        ],
      ),
    );
  }
// List<String> covertImgShop(List<ProductImage> image) {
//   List<String> imageList = <String>[];
//   if (image.length != 0) {
//     imageList.add("${Env.value.baseUrl}/storage/images/${image[0].path}");
//   }else{
//     imageList.add("");
//   }
//   return imageList;
//
// }
}

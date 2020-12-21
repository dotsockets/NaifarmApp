
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../SizeUtil.dart';

class ShopOwn extends StatelessWidget {
  final ProductModel productDetail;

  const ShopOwn({Key key, this.productDetail}) : super(key: key);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child:
                        Lottie.asset(Env.value.loadingAnimaion, height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: productDetail.ProfiletImage,
                      errorWidget: (context, url, error) => Container(
                          height: 30,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                  ),
                ),
                SizedBox(width: 20),
               Expanded(
                 flex: 4,
                 child:  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(productDetail.shopName,
                         style: FunctionHelper.FontTheme(
                             fontSize: SizeUtil.titleSmallFontSize(), color: Colors.black,height: 1,fontWeight: FontWeight.bold)),
                     SizedBox(height: 5),
                     Text(productDetail.acticeTime,
                         style: FunctionHelper.FontTheme(
                             fontSize: SizeUtil.titleSmallFontSize(),
                             color: Colors.black.withOpacity(0.8))),
                     SizedBox(height: 2),
                     Text(productDetail.provice,
                         style: FunctionHelper.FontTheme(
                             fontSize: SizeUtil.titleSmallFontSize(),
                             color: Colors.black.withOpacity(0.8),height: 1.5)),
                   ],
                 ),
               ),
                Container(

                  child: FlatButton(
                    color: ThemeColor.primaryColor(),
                    textColor: Colors.white,
                    padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                    splashColor: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      AppRoute.Followers(context);
                    },
                    child: Text(
                      LocaleKeys.shop_follow.tr(),
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          )
          ,
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("${productDetail.ownProduct}",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.priceFontSize(),
                            color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    Text(LocaleKeys.shop_product_list.tr(),
                        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize()))
                  ],
                ),
                SizedBox(width: 10),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  width: 1,
                  height: 50,
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        Text("${productDetail.rateShow}",
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.priceFontSize(),
                                color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500)),
                        SizedBox(width: 10),
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRated: (v) {},
                            starCount: 5,
                            rating: productDetail.rateShow,
                            size: 25.0,
                            isReadOnly: false,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half_outlined,
                            color: Colors.amber,
                            borderColor: Colors.amber,
                            spacing: 0.0)
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(LocaleKeys.shop_rate.tr(),
                        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize())),
                  ],
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  width: 1,
                  height: 50,
                ),
                SizedBox(width: 5),

                Column(
                  children: [
                    Text("3",
                        style: FunctionHelper.FontTheme(fontSize: SizeUtil.priceFontSize(),color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold)),
                    SizedBox(height: 5,),
                    Text(LocaleKeys.shop_follower.tr(),
                        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize())),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}

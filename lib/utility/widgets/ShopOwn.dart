
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/MarketObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/ImageFullScreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';
import '../SizeUtil.dart';
import 'ProductLandscape.dart';

class ShopOwn extends StatelessWidget {
  final ShopItem shopItem;
  final MyShopRespone shopRespone;
  final bool showBtn;


  const ShopOwn({Key key, this.shopItem,this.shopRespone, this.showBtn=true}) : super(key: key);
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
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      width: 15.0.w,
                      height: 15.0.w,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child:
                        Lottie.asset(Env.value.loadingAnimaion,width: 30, height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: shopItem.image!=null?ProductLandscape.CovertUrlImage(shopItem.image):"",
                      errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundColor: Color(0xffE6E6E6),
                            radius: 30,
                            child: Icon(
                              Icons.shopping_bag_rounded,
                              color: Color(0xffCCCCCC),
                            ),
                          )),
                    ),
                  ),
                  onTap: (){
                    AppRoute.ImageFullScreenView(hero_tag: "image_profile_me${shopItem.id}",context: context,image: ProductLandscape.CovertUrlImage(shopItem.image));
                  },
                ),
                SizedBox(width: 20),
               Expanded(
                 flex: 4,
                 child:  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(shopItem.name!=null?shopItem.name:"Nifarm Shop",
                         style: FunctionHelper.FontTheme(
                             fontSize: SizeUtil.titleSmallFontSize().sp, color: Colors.black,height: 1,fontWeight: FontWeight.bold)),
                     SizedBox(height: 5),
                     Text("${FunctionHelper.TimeAgo(shopItem.updatedAt)} ",
                         style: FunctionHelper.FontTheme(
                             fontSize: SizeUtil.titleSmallFontSize().sp,
                             color: Colors.black.withOpacity(0.8))),
                     SizedBox(height: 2),
                     Text("${shopItem.state!=null?shopItem.state.name:'จังหวัดไม่ถูกต้อง'}",
                         style: FunctionHelper.FontTheme(
                             fontSize: SizeUtil.titleSmallFontSize().sp,
                             color: Colors.black.withOpacity(0.8),height: 1.5)),
                   ],
                 ),
               ),
               showBtn? Container(

                  child: FlatButton(
                    color: ThemeColor.primaryColor(),
                    textColor: Colors.white,
                    padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                    splashColor: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      AppRoute.ShopMain(context: context,myShopRespone: shopRespone);
                    },
                    child: Text(
                      LocaleKeys.shop_title.tr(),
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.w500),
                    ),
                  ),
                ):SizedBox()
              ],
            ),
          ),
          Container(color: Colors.white,height: 10,width: MediaQuery.of(context).size.width,),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 10, right: 20, bottom: 10, top: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text("${shopItem.countProduct!=null?shopItem.countProduct:'0'}",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.priceFontSize().sp,
                              color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Text(LocaleKeys.shop_product_list.tr(),
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp))
                    ],
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${shopItem.rating!=null?shopItem.rating:'0'}",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.priceFontSize().sp,
                                  color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500)),
                          SizedBox(width: 10),
                          SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {},
                              starCount: 5,
                              rating: shopItem.rating!=null?shopItem.rating.toDouble():0,
                              size: 18.0,
                              isReadOnly: true,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half_outlined,
                              color: Colors.amber,
                              borderColor: Colors.amber,
                              spacing: 0.0)
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(LocaleKeys.shop_rate.tr(),
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp)),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text("3",
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.priceFontSize().sp,color: ThemeColor.ColorSale(),fontWeight: FontWeight.bold)),
                      SizedBox(height: 5,),
                      Text(LocaleKeys.shop_follower.tr(),
                          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp)),
                    ],
                  ),
                )
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

}

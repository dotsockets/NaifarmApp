
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductItemCard extends StatelessWidget {


  final String tagHero;
  final ProductData item;
  final int subFixId;
  final bool showSoldFlash;
  final Function onClick;

  ProductItemCard({Key key, this.tagHero, this.subFixId=1,this.item,this.showSoldFlash=false,this.onClick}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(tagHero!="flash"?0:1.0.w),
      child: Column(
        children: [
          _ProductImage(context),
          _intoProduct(context)
        ],
      ),
    );
  }

  Widget _ProductImage(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade400),
        borderRadius: BorderRadius.all(Radius.circular(10)),

      ),
      child: Stack(
        children: [
          Hero(
            tag: "${tagHero}_${item.id}${subFixId}",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.3.h),
              child: CachedNetworkImage(
                width: tagHero!="flash"?30.0.w:(MediaQuery.of(context).size.width / 2) - 15,
                height: tagHero!="flash"?30.0.w:40.0.w,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Lottie.asset('assets/json/loading.json',   width: 30.0.w,
                    height: 30.0.w,),
                ),
                imageUrl: CovertUrlImage(item.image),
                errorWidget: (context, url, error) => Container(width: 30.0.w,
                    height: 30.0.w,child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
              ),
            ),
          ),
          Visibility(
            child: Container(
              margin: EdgeInsets.all(1.5.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.0.w),
                child: Container(
                  padding: EdgeInsets.only(right: 1.5.w,left: 1.5.w,top: 1.0.w,bottom: 1.0.w),
                  color: ThemeColor.ColorSale(),
                  child: Text("${item.discountPercent}%",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
                ),
              ),
            ),
            visible: item.discountPercent>0?true:false,
          )
        ],
      ),
    );
  }

  static String CovertUrlImage(List<ProductImage> image){
    if(image.length!=0){
      Random random = new Random();
      int randomNumber = random.nextInt(image.length); // from
        return "${Env.value.baseUrl}/storage/images/${image[0].path}";
    }else{
      return "";
    }
  }

  Widget _intoProduct(BuildContext context){
    return Container(
      width: tagHero!="flash"?30.0.w:(MediaQuery.of(context).size.width / 2) - 15,
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Container(
            height: SizeUtil.titleSmallFontSize().sp*2.7,
            child: Text(" "+item.name+" ",
              textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,maxLines: 2,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.w500,fontSize: SizeUtil.titleSmallFontSize().sp),),
          ),
          SizedBox(
            height: 0.8.h,
          ),
          SalePrice(item: item),
          SizedBox(height: 1.0.h),
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
                  borderColor: Colors.amber,
                  spacing: 0.0),
              SizedBox(width: 1.0.w,),
            //  Text("${item.rating.toDouble()}",style: FunctionHelper.FontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
            ],
          ),
          showSoldFlash?Stack(
            children: [
              Container(
                padding: EdgeInsets.all(0.8.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0.h),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 3.0.w, right: 2.0.w, bottom: 1.0.w, top: 1.0.w),
                    color: ThemeColor.ColorSale(),
                    child: Text("${item.saleCount!=null?item.saleCount.toString():'0'} ${LocaleKeys.my_product_sold_end.tr()}" ,
                      style: FunctionHelper.FontTheme(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeUtil.detailSmallFontSize().sp),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/svg/flash.svg',
                width: 8.0.w,
                height: 8.0.w,
              )
            ],
          ):Container(
            padding: EdgeInsets.all(0.8.h),
            child: Container(
              padding: EdgeInsets.only(left: 15,right: 7,bottom: 3,top: 3),
              child:  Text(LocaleKeys.my_product_sold.tr()+" "+item.saleCount.toString().replaceAll("null", "0")+" "+LocaleKeys.cart_piece.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.w500,fontSize: SizeUtil.detailSmallFontSize().sp),),
            ),
          )
        ],
      ),
    );
  }

  Row SalePrice({ProductData item}){
      if(item.salePrice!=null){
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            item.offerPrice!=null?Text("${item.salePrice}",style: FunctionHelper.FontTheme(
                color: Colors.grey,
                fontSize: SizeUtil.priceFontSize().sp-2, decoration: TextDecoration.lineThrough)):SizedBox(),
            SizedBox(width: item.offerPrice!=null?1.0.w:0),
            Text(item.offerPrice!=null?"฿${item.offerPrice}":"฿${item.salePrice}",maxLines: 1,
              overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
          ],
        );
      }else{
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
        Text(item.minPrice!=null?"฿${item.minPrice}":"฿0",maxLines: 1,
          overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
            Text(" - ",maxLines: 1,
              overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
            Text(item.maxPrice!=null?"฿${item.maxPrice}":"฿0",maxLines: 1,
              overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
          ],
        );
      }
  }

}

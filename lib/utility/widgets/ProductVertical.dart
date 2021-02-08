import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'ProductLandscape.dart';

class ProductVertical extends StatelessWidget {
  final String titleInto;
  final Function() onSelectMore;
  final Function(ProductData,int) onTapItem;
  final String IconInto;
  final  bool borderRadius;
  final String tagHero;
  final double IconSize;
  final ProductRespone productRespone;

  const ProductVertical({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.IconInto, this.borderRadius, this.tagHero, this.IconSize=35,this.productRespone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius?40:0),topRight:  Radius.circular(borderRadius?40:0)),
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
            _header_bar(),
            productRespone!=null?Column(
              children: List.generate(productRespone.data.length, (index) => _buildCardProduct(context,item: productRespone.data[index],index: index)),
            ):SizedBox()
          ],
        ),
      ),
    );
  }



  Container _header_bar() => Container(
    margin: EdgeInsets.all(1.5.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
           // Image.asset(IconI=nto,width: 50,height: 50,),
            SvgPicture.asset(IconInto,width: IconSize,height: IconSize,),
            SizedBox(width: 2.0.w),
            Text(titleInto,style: FunctionHelper.FontTheme(color: Colors.black,fontSize:SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
          ],
        ),
        InkWell(
          child: Row(
            children: [
              Text(LocaleKeys.recommend_see_more.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize:SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500)),
              SizedBox(width: 2.0.w),
              SvgPicture.asset('assets/images/svg/next.svg',width: 3.0.w,height: 3.0.h,),

            ],
          ),
          onTap: (){
            onSelectMore();
          },
        )
      ],
    ),
  );

  _buildCardProduct(BuildContext context,{ProductData item,int index}){
    return InkWell(
      onTap: (){
        onTapItem(item,index);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 2.0.w,right: 2.0.w),
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
                            border: Border.all(width: 1, color: Colors.grey.shade400),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Hero(
                          tag: "${tagHero}_${index}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.h),
                            child: CachedNetworkImage(
                              width: 28.0.w,
                              height: 35.0.w,
                              placeholder: (context, url) => Container(
                                color: Colors.white,
                                child: Lottie.asset('assets/json/loading.json',   width: 28.0.w,
                                  height: 35.0.w,),
                              ),
                              imageUrl: ProductLandscape.CovertUrlImage(item.image),
                              errorWidget: (context, url, error) => Container(    width: 28.0.w,
                                  height: 35.0.w,child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
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
                ),
                SizedBox(width: 15,),
                Expanded(
                  flex: 3,
                  child: _buildInfoProduct(item: item),
                )
              ],
            ),
            SizedBox(height: 10,),
            productRespone.data.length!=index?Divider(color: Colors.black.withOpacity(0.3)):SizedBox(height: 30,),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoProduct({ProductData item}){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4.0.h,
            child: Text(item.name,maxLines: 2,
                textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: Colors.black,fontSize:   SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 0.8.h,
          ),
          Row(

            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              item.offerPrice!=null?Text("${item.salePrice}",style: FunctionHelper.FontTheme(
                  color: Colors.grey,
                  fontSize: SizeUtil.priceFontSize().sp-2, decoration: TextDecoration.lineThrough)):SizedBox(),
              SizedBox(width: item.offerPrice!=null?1.0.w:0),
              Text(item.offerPrice!=null?"฿${item.offerPrice}":"฿${item.salePrice}",maxLines: 1,
                overflow: TextOverflow.ellipsis,style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
            ],
          ),

          SizedBox(height: 1.0.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.my_product_sold.tr()+" "+item.saleCount.toString().replaceAll("null", "0")+" "+LocaleKeys.cart_piece.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize:  SizeUtil.detailSmallFontSize().sp),),
                  SizedBox(height: 5),
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
                      Text("${item.rating.toDouble()}",style: FunctionHelper.FontTheme(color: Colors.grey.shade400,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 2.0.w),
                padding: EdgeInsets.only(right: 3.0.w,left: 3.0.w,top: 1.5.w,bottom: 1.5.w),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child: Text(LocaleKeys.buy_now_btn.tr(),style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
              )
            ],
          )
        ],
      ),
    );
  }

}

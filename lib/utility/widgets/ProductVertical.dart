import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ProductVertical extends StatelessWidget {
  final String titleInto;
  final Function() onSelectMore;
  final Function(int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final  bool borderRadius;
  final String tagHero;
  final double IconSize;

  const ProductVertical({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.IconInto, this.producViewModel, this.borderRadius, this.tagHero, this.IconSize=35}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius?40:0),topRight:  Radius.circular(borderRadius?40:0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            _header_bar(),
            Column(
              children: List.generate(producViewModel.length, (index) => _buildCardProduct(item: producViewModel[index],index: index)),
            )
          ],
        ),
      ),
    );
  }


  Container _header_bar() => Container(
      child: Container(
        margin: EdgeInsets.all(1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
               // Image.asset(IconI=nto,width: 50,height: 50,),
                SvgPicture.asset(IconInto,width: 10.0.w,height: 10.0.w,),
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
      )
  );

  _buildCardProduct({ProductModel item,int index}){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 2.0.w,right: 2.0.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: "${tagHero}_${index}",
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                          child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                        ),
                        height: 15.0.h,
                        width: 15.0.h,
                        fit: BoxFit.contain,
                        imageUrl: item.product_image,
                        errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildInfoProduct(item: item),
                )
              ],
            ),
            producViewModel.length!=index+1?Divider(color: Colors.black.withOpacity(0.5)):SizedBox()
          ],
        ),
      ),
      onTap: (){
        onTapItem(index);
      },
    );
  }

  Widget _buildInfoProduct({ProductModel item}){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.product_name,style: FunctionHelper.FontTheme(color: Colors.black,fontSize:   SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
          SizedBox(height: 1.0.h,),
          Text("฿${item.product_price}",style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize:  SizeUtil.priceFontSize().sp),),
          SizedBox(height: 0.8.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(LocaleKeys.my_product_sold.tr()+" "+item.product_status+" "+LocaleKeys.cart_item.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize:  SizeUtil.detailSmallFontSize().sp),),
                  SizedBox(height: 0.8.h),
                  Row(
                    children: [
                      Icon(Icons.location_pin,color: Color(ColorUtils.hexToInt("#666666")),),
                      SizedBox(width: 0.3.w,),
                      Text('เชียงใหม่',style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.w500,fontSize:  SizeUtil.detailFontSize().sp),)
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

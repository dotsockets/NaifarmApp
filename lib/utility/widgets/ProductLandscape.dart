
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

class ProductLandscape extends StatelessWidget {

  final String titleInto;
  final Function() onSelectMore;
  final Function(int) onTapItem;
  final String IconInto;
  final List<ProductModel> producViewModel;
  final String tagHero;
  final bool showIcon;
  final bool showPriceSale;


  const ProductLandscape({Key key, this.titleInto, this.onSelectMore, this.onTapItem, this.producViewModel, this.IconInto, this.tagHero,this.showIcon = true,this.showPriceSale=true}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header_bar(),
            _flashProduct()
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
                Visibility(child: SvgPicture.asset(IconInto,width: 3.0.w,height: 3.0.h,),visible: showIcon,
                ),
                SizedBox(width: 2.0.w),
                Text(titleInto,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
              ],
            ),
            GestureDetector(
              child: Row(
                children: [
                  Text(LocaleKeys.recommend_see_more.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500)),
                  SizedBox(width: 2.0.w),
                  SvgPicture.asset('assets/images/svg/next.svg',width: 3.0.w,height: 3.0.h,),
                ],
              ),
                onTap: ()=>onSelectMore()
            )
          ],
        ),
      )
  );

  Widget _flashProduct(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(producViewModel.length, (index){
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  _ProductImage(item: producViewModel[index],index: index),
                  _intoProduct(item: producViewModel[index])
                ],
              ),
            ),
            onTap: ()=>onTapItem(index),
          );
        }),
      ),
    );
  }



  Widget _ProductImage({ProductModel item,int index}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(1.0.h),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2,color: Colors.grey.shade200)
        ),
        child: Stack(
          children: [
            Hero(
              tag: "${tagHero}_${index}",
              child: CachedNetworkImage(
                width: 30.0.w,
                height: 30.0.w,
                placeholder: (context, url) => Container(
                  color: Colors.white,
                  child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                ),
                fit: BoxFit.contain,
                imageUrl: item.product_image,
                errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
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
                    child: Text("40%",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
                  ),
                ),
              ),
              visible: showPriceSale,
            )
          ],
        ),
      ),
    );
  }

  Widget _intoProduct({ProductModel item}){
    return Container(
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Text(item.product_name,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize().sp),),
          SizedBox(height: 0.8.h),
          Text("฿${item.product_price}",style: FunctionHelper.FontTheme(color: ThemeColor.ColorSale(),fontWeight: FontWeight.w500,fontSize: SizeUtil.priceFontSize().sp),),
          Container(
            padding: EdgeInsets.all(0.8.h),
            child: Container(
              child:  Text(LocaleKeys.my_product_sold.tr()+" "+item.product_status+" "+LocaleKeys.cart_item.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.detailSmallFontSize().sp),),
            ),
          )
        ],
      ),
    );
  }
}

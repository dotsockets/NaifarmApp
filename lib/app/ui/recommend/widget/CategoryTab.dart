
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';

import 'package:sizer/sizer.dart';

class CategoryTab extends StatelessWidget {
  final CategoryGroupRespone categoryGroupRespone;

   CategoryTab({Key key, this.categoryGroupRespone}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          _header_bar(),
          categoryGroupRespone!=null?_flashProduct(context):SizedBox()
        ],
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
                SvgPicture.asset('assets/images/svg/boxes.svg',width: 5.0.w,height: 5.0.w,),
                SizedBox(width: 2.0.w),
                Text(LocaleKeys.recommend_category_product.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                Text(LocaleKeys.recommend_change.tr(),style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleFontSize().sp)),
                SizedBox(width: 2.0.w),
                SvgPicture.asset('assets/images/svg/change.svg',width: 3.0.w,height: 3.0.h,),

              ],
            )
          ],
        ),
      )
  );

  Widget _flashProduct(BuildContext context){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categoryGroupRespone.data.length, (index){
          return Container(
            margin: EdgeInsets.only(top: 0.5.h),
            child: Column(
              children: [
                _ProductImage(context,item: categoryGroupRespone.data[index],index: index)
              ],
            ),
          );
        }),
      ),
    );
  }



  Widget _ProductImage(BuildContext context,{CategoryGroupData item,int index}){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(2.0.h),
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 2,color: Colors.grey.shade200),
              bottom: BorderSide(width: 2,color: Colors.grey.shade200),
              right: BorderSide(width: 2,color: Colors.grey.shade200),
              left: BorderSide(width: index==0?2:0,color: Colors.grey.shade200)
            )
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              width: 18.0.w,
              height: 18.0.w,
              placeholder: (context, url) => Container(
                color: Colors.white,
                child: Lottie.asset('assets/json/loading.json', width: 18.0.w,
                  height: 18.0.w,),
              ),
              fit: BoxFit.cover,
              imageUrl: "https://dev2-test.naifarm.com/category-icon/${item.icon}.png",
              errorWidget: (context, url, error) => Container( width: 18.0.w,
                height: 18.0.w,child: Icon(Icons.error,size: 30,)),
            ),
            SizedBox(height: 2.0.h),
            Text(item.name,style: FunctionHelper.FontTheme(color: Colors.black,fontSize: SizeUtil.titleSmallFontSize().sp,fontWeight: FontWeight.bold),),
            SizedBox(height: 1.0.h),
          ],
        ),
      ),
      onTap: (){
        AppRoute.CategoryDetail(context, item.id,title: item.name);
      },
    );
  }


}

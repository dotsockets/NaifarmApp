import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class RecommendMenu extends StatelessWidget {

  final List<MenuModel> _menuViewModel = MenuViewModel().getRecommendmenu();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 2.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _menuViewModel.asMap().map((key, value){
              return MapEntry(key, _menuBox(item: value,index: key,context: context));
            }).values.toList(),
          ),
      ),
    );
  }

  Widget _menuBox({MenuModel item,int index,BuildContext context}){
    return InkWell(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(1.0.w),
                child: SvgPicture.asset(item.icon,width: 13.0.w,height: 14.0.w,),
              ),
              index==3?Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(1.0.h),
                  decoration: BoxDecoration(
                    color: ThemeColor.ColorSale(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 1.0.w,
                    minHeight: 1.0.h,
                  ),
                ),
              ):SizedBox()
            ],
          ),
          SizedBox(height: 0.1.h),
          Text(item.label,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.detailFontSize().sp))
        ],
      ),
    onTap: (){
      switch(item.page){
        case  "ShopMyNear" : AppRoute.ShopMyNear(context);
        break;
        case  "MarketView" : AppRoute.Market(context);
        break;
        case  "SpecialproductsView" : AppRoute.ProductMore(context,LocaleKeys.recommend_special_price_product.tr(),ProductViewModel().getMarketRecommend());
        break;
        case  "NotiView" :  AppRoute.MyNoti(context);
        break;
        case  "MyLikeView" :  AppRoute.ProductMore(context,LocaleKeys.me_title_likes.tr(),ProductViewModel().getMarketRecommend());
        break;
      }
    },
    );
  }
}

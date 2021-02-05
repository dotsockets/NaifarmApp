
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class CaregoryShopView extends StatelessWidget {
  final CategoryGroupRespone categoryGroupRespone;
  final int ShopId;

  const CaregoryShopView({Key key, this.categoryGroupRespone, this.ShopId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: categoryGroupRespone.data.asMap().map((key, value) => MapEntry(key, _BuildMenu(context,categoryGroupRespone.data[key]))).values.toList(),
        ),
      ),
    );
  }

  Widget _BuildMenu(BuildContext context,CategoryGroupData item){
    return InkWell(
      child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10,top: 10,left: 20,right: 10),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black)),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Text("${item.countProduct} "+LocaleKeys.shop_product_list.tr(),style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.detailFontSize().sp,color: Colors.black.withOpacity(0.5))),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,)
                    ],
                  )
                ],
              ),
            ),
            Divider(color: Colors.grey.shade500,)
          ],
      ),
      onTap: (){
        AppRoute.ProductMore(
            api_link: "products/types/popular?shopId=${ShopId}&categoryId=${item.id}",
            context: context,
            barTxt: item.name);
      },
    );
  }
}

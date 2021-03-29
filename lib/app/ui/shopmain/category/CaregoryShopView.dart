import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class CaregoryShopView extends StatelessWidget {
  final CategoryGroupRespone categoryGroupRespone;
  final int shopId;

  const CaregoryShopView({Key key, this.categoryGroupRespone, this.shopId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: categoryGroupRespone.data
              .asMap()
              .map((key, value) => MapEntry(
                  key, buildMenu(context, categoryGroupRespone.data[key])))
              .values
              .toList(),
        ),
      ),
    );
  }

  Widget buildMenu(BuildContext context, CategoryGroupData item) {
    return InkWell(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            padding: EdgeInsets.only(
                bottom: 1.5.h, top: 1.5.h, left: 4.0.w, right: 2.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name,
                    style: FunctionHelper.fontTheme(
                        fontWeight: FontWeight.w500,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        color: Colors.black)),
                SizedBox(width: 10),
                Row(
                  children: [
                    Text(
                        "${item.countProduct} " +
                            LocaleKeys.shop_product_list.tr(),
                        style: FunctionHelper.fontTheme(
                            fontWeight: FontWeight.w500,
                            fontSize: SizeUtil.detailFontSize().sp,
                            color: Colors.black.withOpacity(0.5))),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade400,
                      size: 4.0.w,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        AppRoute.productMore(
            apiLink:
                "products/types/popular?shopId=$shopId&categoryId=${item.id}",
            context: context,
            barTxt: LocaleKeys.shop_product_list.tr());
      },
    );
  }
}

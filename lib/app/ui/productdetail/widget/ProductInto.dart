
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ProductInto extends StatelessWidget {
  final ProductModel productDetail;

  const ProductInto({Key key, this.productDetail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 1.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 4,
                child: Center(
                    child: Text(
                      productDetail.product_name,
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.priceFontSize().sp, fontWeight: FontWeight.w500),
                    )),
              ),
              Expanded(flex: 1, child: SvgPicture.asset(
                'assets/images/svg/like_line_null.svg',
                width: 9.0.w,
                height: 9.0.w,
                color: Colors.black.withOpacity(0.7),
              ))
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${productDetail.product_price}",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.priceFontSize().sp, decoration: TextDecoration.lineThrough)),
              SizedBox(width: 8),
              Text("${productDetail.ProductDicount}",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.priceFontSize().sp, color: ThemeColor.ColorSale()))
            ],
          ),
          SizedBox(height: 10),
          Text(
            productDetail.product_status+" "+LocaleKeys.my_product_sold_end.tr(),
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          SizedBox(height: 15),
          _IntroShipment()
        ],
      ),
    );
  }

  Widget _IntroShipment() {
    return Container(
      color: ThemeColor.primaryColor().withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/svg/delivery.svg',
              width: 8.0.w,
              height: 8.0.w,
            ),
            SizedBox(width: 2.0.w),
            Text(LocaleKeys.cart_free.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp, color: ThemeColor.ColorSale())),
            Text(LocaleKeys.cart_delivery_free.tr(),
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ProductInto extends StatelessWidget {
  final ProducItemRespone data;

  const ProductInto({Key key, this.data}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
              child: Container(
                width: 80.0.w,
                child: Text(
                  data.name.toString(),
                  textAlign: TextAlign.center,
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.priceFontSize().sp, fontWeight: FontWeight.w500),
                ),
              )),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              data.offerPrice!=null?Text("${data.salePrice}",
                  style: FunctionHelper.FontTheme(color: Colors.grey,
                      fontSize: SizeUtil.priceFontSize().sp-2, decoration: TextDecoration.lineThrough)):SizedBox(),
              SizedBox(width: data.offerPrice!=null?1.0.w:0),
              Text(data.offerPrice!=null?"฿${data.offerPrice}":"฿${data.salePrice}",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.priceFontSize().sp, color: ThemeColor.ColorSale()))
            ],
          ),
          SizedBox(height: 10),
          Text(
          "${data.saleCount!=null? data.saleCount.toString():'0'} ${LocaleKeys.my_product_sold_end.tr()}",
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

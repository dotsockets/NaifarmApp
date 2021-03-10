import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/DiscountModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class ModalFitBottom_Sheet extends StatelessWidget {
  final DiscountModel discountModel;

  const ModalFitBottom_Sheet({Key key, this.discountModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              LocaleKeys.cart_discount_from.tr() + " ไร่มอนหลวงสาย",
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: discountModel.detail
                  .asMap()
                  .map((key, value) => MapEntry(
                      key, _BuildCard(item: discountModel.detail[key])))
                  .values
                  .toList(),
            ),
            SizedBox(height: 5.0.h),
          ],
        ),
      ),
    );
  }

  Widget _BuildCard({DetailModel item, BuildContext context}) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 15, left: 15, top: 15),
            child: Row(
              children: [
                !item.isDelivery
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          width: 10.0.w,
                          height: 10.0.w,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child: Lottie.asset('assets/json/loading.json',
                                height: 30),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: item.ShopImage,
                          errorWidget: (context, url, error) => Container(
                              width: 10.0.w,
                              height: 10.0.w,
                              child: Icon(
                                Icons.error,
                                size: 1.0.w,
                              )),
                        ),
                      )
                    : SvgPicture.asset('assets/images/svg/delivery.svg',
                        width: 10.0.w, height: 10.0.w),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.Title,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(item.SubTitle,
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.5))),
                    ],
                  ),
                ),
                item.price > item.minimum
                    ? _buildButton(isUse: item.isUse, context: context)
                    : SizedBox()
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          item.LabelText != ""
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.amberAccent.withOpacity(0.2),
                      border: Border.all(color: Colors.grey.shade300)),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.LabelText,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            LocaleKeys.cart_add_more.tr(),
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleSmallFontSize().sp,
                                fontWeight: FontWeight.w500,
                                color: ThemeColor.ColorSale()),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade400,
                            size: 5.0.w,
                          )
                        ],
                      )
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget _buildButton({bool isUse, BuildContext context}) {
    return Container(
      width: 20.0.w,
      height: 40,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.black.withOpacity(0.2),
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0),
          )),
          padding: MaterialStateProperty.all(
              EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10)),
          backgroundColor: MaterialStateProperty.all(
            isUse ? Colors.white : ThemeColor.primaryColor(),
          ),
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.3),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          isUse ? LocaleKeys.cart_used.tr() : LocaleKeys.cart_use.tr(),
          style: FunctionHelper.FontTheme(
              color: isUse ? Colors.black.withOpacity(0.5) : Colors.white,
              fontSize: SizeUtil.titleSmallFontSize().sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

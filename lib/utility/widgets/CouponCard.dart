import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:sizer/sizer.dart';

import '../SizeUtil.dart';

class CouponCard extends StatelessWidget {
  final CouponData couponData;
  final Function onTab;
  final bool isEnable;
  final int cartId;
  final Function onDelete;

  const CouponCard({
    Key key,
    @required this.couponData,
    @required this.onTab,
    this.isEnable = true,
    this.cartId,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.isEnable
          ? () {
              this.onTab();
            }
          : () {},
      child: Container(
        decoration: BoxDecoration(
          color: this.isEnable ? Colors.white : Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 15),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    child: Image.asset(
                      'assets/images/png/sale_cart.png',
                      width: 10.0.w,
                      height: 10.0.h,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          this.couponData.code,
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleSmallFontSize().sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          this.couponData.name,
                          style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          LocaleKeys.coupon_coupon_enddate.tr() +
                              " " +
                              DateFormat('yyyy-MM-dd').format(
                                DateTime.parse(this.couponData.endingTime),
                              ),
                          style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Center(
                        child: Text(
                          this.couponData.value.toString() +
                              (this.couponData.type.toLowerCase() == "amount"
                                  ? ".-"
                                  : "%"),
                          overflow: TextOverflow.ellipsis,
                          style: FunctionHelper.fontTheme(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onDelete != null
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              border: Border.all(
                                color: Colors.red,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.grey.shade200,
                                  ),
                                ),
                                onPressed: () => this.onDelete(),
                                child: Text(
                                  LocaleKeys.cart_del.tr(),
                                  style: FunctionHelper.fontTheme(
                                      color: Colors.red,
                                      fontSize: SizeUtil.titleFontSize().sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

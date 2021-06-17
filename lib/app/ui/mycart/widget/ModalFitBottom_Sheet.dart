import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/CouponCard.dart';
import 'package:sizer/sizer.dart';

class ModalFitBottomSheet extends StatelessWidget {
  final CouponResponse couponResponse;
  final CouponData couponData;
  final CartData cartData;
  final String title;
  final Function onSelectedCoupon;
  final Function onDeleteCoupon;

  const ModalFitBottomSheet({
    Key key,
    @required this.couponResponse,
    this.couponData,
    this.cartData,
    this.title,
    this.onSelectedCoupon,
    this.onDeleteCoupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 80.0.h,
        ),
        padding: EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                this.title,
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              this.couponData == null
                  ? Column(
                      children: this
                          .couponResponse
                          .data
                          .map((e) => CouponCard(
                                couponData: e,
                                isEnable:
                                    this.cartData.grandTotal >= e.minOrderAmount
                                        ? true
                                        : false,
                                onTab: () => this.onSelectedCoupon(e),
                              ))
                          .toList(),
                    )
                  : editCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget editCard() {
    var data =
        this.couponResponse.data.where((e) => e.id == this.couponData.id);
    return data.length > 0
        ? CouponCard(
            couponData: data.first,
            cartId: this.cartData.id,
            onTab: () => {},
            onDelete: () => this.onDeleteCoupon(),
          )
        : Container();
  }
}

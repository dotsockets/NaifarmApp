import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/CouponCard.dart';
import 'package:sizer/sizer.dart';

class ModalFitBottomSheet extends StatelessWidget {
  final CouponResponse couponResponse;
  final String title;

  const ModalFitBottomSheet(
      {Key key, @required this.couponResponse, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.grey.shade300,
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
              Column(
                children: couponResponse.data
                    .map((e) => CouponCard(couponData: e, onTab: () {}))
                    .toList(),
              ),
              SizedBox(height: 5.0.h),
            ],
          ),
        ),
      ),
    );
  }
}

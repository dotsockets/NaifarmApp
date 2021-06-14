import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:sizer/sizer.dart';

class CouponCard extends StatelessWidget {
  final CouponData couponData;
  final Function onTab;
  const CouponCard({Key key, @required this.couponData, @required this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        this.onTab();
      },
      child: Container(
        width: 100.0.w,
        height: 15.0.h,
        margin: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5.0.h,
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
              child: Text(
                this.couponData.code,
                style: FunctionHelper.fontTheme(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 5.0.h,
              child: Center(
                child: Text(
                  this.couponData.value.toString() +
                      (this.couponData.type == "amount" ? ".-" : "%"),
                  style: FunctionHelper.fontTheme(
                    fontSize: 30.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 5.0.h,
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
              child: Text(
                "Expire: " +
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(this.couponData.endingTime)),
                style: FunctionHelper.fontTheme(
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

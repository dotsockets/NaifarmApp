
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/order/widget/OrderDetail.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers.dart';

class OrderMobile extends StatelessWidget {
  final String orderTitle;
  final String orderTitleDetail;
  const OrderMobile({Key key,this.orderTitle,this.orderTitleDetail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade300,
            child: StickyHeader(
              header:  Column(
                children: [
                  AppToobar(Title: "รายละเอียดคำสั่งซื้อ",header_type:  Header_Type.barNormal,icon: "",),
                  OrderDetail(headOrder: orderTitle,headOrderDetail: orderTitleDetail
                    ,headOrderDate: "เวลาที่สำเร็จ 28-06-2563 18.39",)
                ],
              ),
              content: Column(
                children: [
                  SizedBox(height: 15),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

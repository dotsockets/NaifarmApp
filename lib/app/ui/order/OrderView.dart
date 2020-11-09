

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'OrderMobile.dart';
import 'Ordertablet.dart';


class OrderView extends StatelessWidget {

  final String orderTitle;
  final String  orderTitleDetail;
  const OrderView({Key key, this.orderTitle,this.orderTitleDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrderMobile(orderTitle:orderTitle, orderTitleDetail: orderTitleDetail),
      tablet: Ordertablet(),
    );
  }
}
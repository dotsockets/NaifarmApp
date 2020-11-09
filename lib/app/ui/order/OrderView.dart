

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'OrderMobile.dart';
import 'Ordertablet.dart';


class OrderView extends StatelessWidget {

  final int  Status_Sell;
  const OrderView({Key key,this.Status_Sell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrderMobile(Status_Sell: Status_Sell,),
      tablet: Ordertablet(),
    );
  }
}
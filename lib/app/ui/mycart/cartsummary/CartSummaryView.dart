

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'CartSummaryMobile.dart';
import 'CartSummarytablet.dart';


class CartSummaryView extends StatelessWidget {
  CartSummaryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CartSummaryMobile(),
      tablet: CartSummarytablet(),
    );
  }
}
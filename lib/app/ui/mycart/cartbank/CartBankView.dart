

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'CartBankMobile.dart';
import 'CartBanktablet.dart';


class CartBankView extends StatelessWidget {
  CartBankView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CartBankMobile(),
      tablet: CartBanktablet(),
    );
  }
}
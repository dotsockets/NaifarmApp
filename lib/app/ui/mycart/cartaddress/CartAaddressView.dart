

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'CartAaddressMobile.dart';
import 'CartAaddresstablet.dart';


class CartAaddressView extends StatelessWidget {
  CartAaddressView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CartAaddressMobile(),
      tablet: CartAaddresstablet(),
    );
  }
}
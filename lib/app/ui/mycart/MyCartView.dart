

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'MyCartMobile.dart';
import 'MyCarttablet.dart';


class MyCartView extends StatelessWidget {
  MyCartView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MyCartMobile(),
      tablet: MyCarttablet(),
    );
  }
}
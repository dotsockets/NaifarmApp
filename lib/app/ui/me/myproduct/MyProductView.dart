

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/me/myproduct/MyProducttablet.dart';
import 'MyProductMobile.dart';


class MyProductView extends StatelessWidget {
  MyProductView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MyProductMobile(),
      tablet: MyProducttablet(),
    );
  }
}


import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';
import 'MyNewProductMobile.dart';
import 'MyNewProducttablet.dart';


class MyNewProductView extends StatelessWidget {
  MyNewProductView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MyNewProductMobile(),
      tablet: MyNewProducttablet(),
    );
  }
}
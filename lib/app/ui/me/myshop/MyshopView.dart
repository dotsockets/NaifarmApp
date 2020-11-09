
import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/ScreenTypeLayout.dart';

import 'MyshopMobile.dart';
import 'Myshoptablet.dart';

class MyshopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MyshopMobile(),
      tablet: Myshoptablet(),
    );
  }
}
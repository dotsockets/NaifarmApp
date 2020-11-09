
import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/ScreenTypeLayout.dart';

import 'SpecialproductsMobile.dart';
import 'Specialproductstablet.dart';

class SpecialproductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SpecialproductsMobile(),
      tablet: Specialproductstablet(),
    );
  }

}

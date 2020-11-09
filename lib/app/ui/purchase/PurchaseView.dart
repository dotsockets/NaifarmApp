
import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/ScreenTypeLayout.dart';

import 'PurchaseMobile.dart';
import 'Purchasetablet.dart';

class PurchaseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: PurchaseMobile(),
      tablet: Purchasetablet(),
    );
  }
}

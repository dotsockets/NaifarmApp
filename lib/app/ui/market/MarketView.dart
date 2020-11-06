

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'MarketMobile.dart';
import 'Markettablet.dart';


class MarketView extends StatelessWidget {
  MarketView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MarketMobile(),
      tablet: Markettablet(),
    );
  }
}
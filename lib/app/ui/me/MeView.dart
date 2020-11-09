

import 'package:naifarm/app/ui/ScreenTypeLayout.dart';
import 'package:flutter/material.dart';

import 'MeMobile.dart';
import 'Metablet.dart';



class MeView extends StatelessWidget {
  MeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MeMobile(),
      tablet: Metablet(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/ScreenTypeLayout.dart';

import 'NotiDetailMobile.dart';
import 'NotiDetailtablet.dart';

class NotiDetailView extends StatelessWidget {
  final String notiImage;
  final String notiTitle;

  const NotiDetailView({Key key, this.notiImage, this.notiTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: NotiDetailMobile(notiImage: notiImage,notiTitle: notiTitle,),
      tablet: NotiDetailtablet(),
    );
  }
}
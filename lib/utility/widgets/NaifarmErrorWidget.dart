import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';

import '../SizeUtil.dart';
import 'package:sizer/sizer.dart';

class NaifarmErrorWidget extends StatelessWidget {

  NaifarmErrorWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Center(
        child: Text("naifarm.com", style: FunctionHelper.fontTheme(
            fontSize: SizeUtil.detailFontSize().sp,color: Colors.grey.shade300,
            fontWeight: FontWeight.w500)),
      ),
    );
  }
}

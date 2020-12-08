
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/utility/SizeUtil.dart';

class CaregoryShopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: MenuViewModel().getMenustype().asMap().map((key, value) => MapEntry(key, _BuildMenu(MenuViewModel().getMenustype()[key]))).values.toList(),
        ),
      ),
    );
  }

  Widget _BuildMenu(MenuModel item){
    return Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 10,top: 10,left: 20,right: 10),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.label,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.titleSmallFontSize(),color: Colors.black)),
                SizedBox(width: 10),
                Row(
                  children: [
                    Text("${Random().nextInt(100)} รายการสินค้า",style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.detailFontSize(),color: Colors.black.withOpacity(0.5))),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,)
                  ],
                )
              ],
            ),
          ),
          Divider(color: Colors.grey.shade500,)
        ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/MarketObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';

class ShopDetailsView extends StatelessWidget {
  final ZipShopObjectCombin zipShopObjectCombin;

  const ShopDetailsView({Key key, this.zipShopObjectCombin}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(zipShopObjectCombin.shopRespone.description
              ,style: FunctionHelper.FontTheme(color: Colors.black.withOpacity(0.7),height: 2),)
            ],
          ),
        ),
      ),
    );
  }
}

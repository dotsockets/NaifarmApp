
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class SpecialproductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppToobar(Title: "สินค้าราคาพิเศษ",header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg'),
        body: SingleChildScrollView(
            child: Container(
              child: ProductGrid(
                producViewModel: ProductViewModel().getMarketRecommend(),
                IconInto: 'assets/images/svg/like.svg',
                onSelectMore: () {

                },
                onTapItem: (int index) {
                  AppRoute.ProductDetail(context,
                      productImage: "special_${index}");
                },EnableHeader: false,tagHero: "special",),
            ),
        ),
      ),
    );
  }
}

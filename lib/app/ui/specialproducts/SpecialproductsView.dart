
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:easy_localization/easy_localization.dart';

class SpecialproductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppToobar(title: LocaleKeys.recommend_special_price_product.tr(),header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg'),
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

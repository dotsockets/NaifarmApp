
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/FlashSale.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:easy_localization/easy_localization.dart';

class Shop extends StatelessWidget {
  Shop({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FlashSale(),
          SizedBox(height: 15),
          ProductLandscape(
              titleInto: LocaleKeys.recommend_best_seller.tr(),
              producViewModel: ProductViewModel().getBestSaller(),
              IconInto: 'assets/images/svg/product_hot.svg',
              onSelectMore: () {},
              onTapItem: (int index) {
                AppRoute.ProductDetail(context,
                    productImage: "product_hot_${index}");
              },
              tagHero: "product_hot"),
          SizedBox(height: 15),
          ProductGrid(titleInto: LocaleKeys.tab_bar_recommend.tr(),
              producViewModel: ProductViewModel().getMarketRecommend(),
              IconInto: 'assets/images/svg/like.svg',
              onSelectMore: () {

              },
              onTapItem: (int index) {

                AppRoute.ProductDetail(context,
                    productImage: "market_farm_${index}");
              },tagHero: 'market_farm' )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:easy_localization/easy_localization.dart';

class Shop extends StatelessWidget {
  final ZipShopObjectCombin productRespone;

  const Shop({Key key, this.productRespone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 15),
          ProductLandscape(
              productRespone: productRespone.productmyshop,
              titleInto: LocaleKeys.recommend_best_seller.tr(),
              iconInto: 'assets/images/svg/product_hot.svg',
              subFixId: 1,
              onSelectMore: () {
                AppRoute.productMore(
                    apiLink:
                        "products/types/popular?shopId=${productRespone.shopRespone.id}",
                    context: context,
                    barTxt: LocaleKeys.recommend_best_seller.tr(),
                    installData: productRespone.productmyshop);
              },
              onTapItem: (ProductData item, int index) {
                AppRoute.productDetail(context,
                    productImage: "shop_product_hot_${item.id}1",
                    productItem: ProductBloc.convertDataToProduct(data: item));
              },
              tagHero: "shop_product_hot"),
          SizedBox(height: 15),
          ProductGrid(
              titleInto: LocaleKeys.tab_bar_recommend.tr(),
              enableHeader: true,
              showSeeMore: true,
              productRespone: productRespone.productrecommend,
              iconInto: 'assets/images/svg/like.svg',
              apiLink: "products",
              onSelectMore: () {
                AppRoute.productMore(
                    apiLink:
                        "products/types/trending?shopId=${productRespone.shopRespone.id}",
                    context: context,
                    barTxt: LocaleKeys.recommend_title.tr(),
                    installData: productRespone.productrecommend);
              },
              onTapItem: (ProductData item, int index) {
                AppRoute.productDetail(context,
                    productImage: "shop_market_farm_${item.id}",
                    productItem: ProductBloc.convertDataToProduct(data: item));
              },
              tagHero: 'shop_market_farm')
        ],
      ),
    );
  }
}

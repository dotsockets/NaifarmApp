
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/pojo/response/MarketObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/FlashSaleBar.dart';
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
              IconInto: 'assets/images/svg/product_hot.svg',
              SubFixId: 1,
              onSelectMore: () {
                AppRoute.ProductMore(api_link: "products/types/popular?shopId=${productRespone.shopRespone.id}",limit: 10,context:context,barTxt:LocaleKeys.recommend_best_seller.tr(),installData: productRespone.productmyshop);

              },
              onTapItem: (ProductData item,int index) {
                AppRoute.ProductDetail(context,
                    productImage: "shop_product_hot_${item.id}1",productItem: ProductBloc.ConvertDataToProduct(data: item) );
              },
              tagHero: "shop_product_hot"),
          SizedBox(height: 15),
          ProductGrid(titleInto: LocaleKeys.tab_bar_recommend.tr(),
              EnableHeader: true,
              showSeeMore: true,
              productRespone: productRespone.productrecommend,
              IconInto: 'assets/images/svg/like.svg',
              api_link: "products",
              onSelectMore: () {
                AppRoute.ProductMore(api_link: "products/types/trending?shopId=${productRespone.shopRespone.id}",limit: 10,context:context,barTxt:LocaleKeys.recommend_best_seller.tr(),installData: productRespone.productrecommend);

              },
              onTapItem: (ProductData item,int index) {

                AppRoute.ProductDetail(context,
                    productImage: "shop_market_farm_${item.id}",productItem: ProductBloc.ConvertDataToProduct(data: item));
              },tagHero: 'shop_market_farm' )
        ],
      ),
    );
  }
}

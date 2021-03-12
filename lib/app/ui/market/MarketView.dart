import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:naifarm/utility/widgets/ProductVertical.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../utility/widgets/BannerSlide.dart';

class MarketView extends StatefulWidget {
  @override
  _MarketViewState createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  final _scrollController = TrackingScrollController();
  // final List<MenuModel> _menuViewModel = MenuViewModel().getMenustype();
  final _indicatorController = IndicatorController();
  // int _categoryselectedIndex = 0;

  ProductBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.loadProductPopular(context, "1");
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return CustomRefreshIndicator(
      controller: _indicatorController,
      onRefresh: () => Future.delayed(const Duration(seconds: 2)),
      loadingToIdleDuration: const Duration(seconds: 1),
      armedToLoadingDuration: const Duration(seconds: 1),
      draggingToIdleDuration: const Duration(seconds: 1),
      leadingGlowVisible: false,
      trailingGlowVisible: false,
      offsetToArmed: 100.0,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                if (!controller.isIdle)
                  Positioned(
                    top: 60 * controller.value,
                    child: SpinKitThreeBounce(
                      color: ThemeColor.primaryColor(),
                      size: 30,
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0, 130.0 * controller.value),
                  child: child,
                ),
              ],
            );
          },
        );
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: Colors.grey.shade300,
              child: StickyHeader(
                header: Column(
                  children: [
                    AppToobar(
                      title: LocaleKeys.market_toobar.tr(),
                      headerType: Header_Type.barcartShop,
                      isEnableSearch: true,
                      onClick: () {
                        AppRoute.searchHome(context);
                      },
                    ),
                  ],
                ),
                content: Column(
                  children: [
                    BannerSlide(),
                    SizedBox(height: 15),
                    StreamBuilder(
                      stream: bloc.productPopular.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ProductVertical(
                              productRespone: snapshot.data,
                              titleInto: LocaleKeys.recommend_best_seller.tr(),
                              iconInto: 'assets/images/svg/product_hot.svg',
                              onSelectMore: () {
                                AppRoute.productMore(
                                    context: context,
                                    barTxt:
                                        LocaleKeys.recommend_best_seller.tr(),
                                    installData: snapshot.data);
                              },
                              onTapItem: (ProductData item, int index) {
                                AppRoute.productDetail(context,
                                    productImage: "sell_$index",
                                    productItem:
                                        ProductBloc.convertDataToProduct(
                                            data: item));
                              },
                              borderRadius: true,
                              iconSize: 30,
                              tagHero: "sell");
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    ProductGrid(
                        titleInto: LocaleKeys.recommend_title.tr(),
                        iconInto: 'assets/images/svg/like.svg',
                        onSelectMore: () {},
                        onTapItem: (ProductData item, int index) {
                          AppRoute.productDetail(context,
                              productImage: "market_farm_$index",
                              productItem:
                                  ProductBloc.convertDataToProduct(data: item));
                        },
                        tagHero: 'market_farm'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

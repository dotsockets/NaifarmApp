import 'dart:math';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/ui/shopmain/shop/Shop.dart';
import 'package:naifarm/app/ui/shopmain/shopdetails/ShopDetailsView.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ShopOwn.dart';
import 'package:sizer/sizer.dart';
import '../../../utility/widgets/MD2Indicator.dart';
import 'category/CaregoryShopView.dart';

class ShopMainView extends StatefulWidget {
  @override
  _ShopMainViewState createState() => _ShopMainViewState();
}

class _ShopMainViewState extends State<ShopMainView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: selectedIndex,
      length: 3,
      vsync: this,
    );

    tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        selectedIndex = tabController.index;
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppToobar(
          title: "ไร่มอนหลวงสาย",
          header_type: Header_Type.barNormal,
          icon: 'assets/images/svg/search.svg',
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                    ShopOwn(productDetail: ProductViewModel().getFlashSaleProduct()[0])
                    ]
                  ),
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: TabBar(
                    indicator: MD2Indicator(
                      indicatorSize: MD2IndicatorSize.tiny,
                      indicatorHeight: 5.0,
                      indicatorColor: ThemeColor.primaryColor(),
                    ),
                    controller: tabController,
                    tabs: [
                      _tabbar(title: LocaleKeys.shop_title.tr(),index: 0),
                      _tabbar(title: LocaleKeys.shop_category.tr(),index: 1),
                      _tabbar(title: LocaleKeys.shop_detail.tr(),index: 2),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Shop(),
                      CaregoryShopView(),
                      ShopDetailsView()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _tabbar({String title, int index}) {
    return Tab(
      child: Container(
        child: Text(title,
            style: FunctionHelper.FontTheme(
                fontWeight: FontWeight.w500,
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: tabController.index == index
                    ? Colors.black
                    : Colors.grey.shade700)),
      ),
    );
  }
}

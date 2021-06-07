import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/paid/PaidView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/shipped/ShippedView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/success/SuccessView.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
import 'package:sizer/sizer.dart';
import 'canceled/CanceledView.dart';
import 'delivery/DeliveryView.dart';

// ignore: must_be_immutable
class ShopOrderHistoryView extends StatelessWidget {
  final int index;
  final bool callback;

  ShopOrderHistoryView({Key key, this.index, this.callback}) : super(key: key);

  int tabCount = 5;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabCount,
      initialIndex: index,
      child: Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.0.h),
              child: AppToobar(
                title: LocaleKeys.me_title_history_shop.tr(),
                headerType: Header_Type.barcartShop,
                icon: '',
                onClick: () {
                  if (callback) {
                    AppRoute.poppageCount(context: context, countpage: 4);
                  } else {
                    AppRoute.poppageCount(context: context, countpage: 1);
                  }
                },
              ),
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: SizeUtil.tabBarHeight().h,
                    width: 100.0.w,
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        indicator: MD2Indicator(
                          indicatorSize: MD2IndicatorSize.normal,
                          indicatorHeight: 0.8.h,
                          indicatorColor: ThemeColor.colorSale(),
                        ),
                        isScrollable: true,
                        tabs: [
                          _tabbar(
                              title: LocaleKeys.me_menu_wait_pay.tr(),
                              message: false),
                          _tabbar(
                              title: LocaleKeys.me_menu_ship.tr(),
                              message: false),
                          _tabbar(
                              title: LocaleKeys.me_menu_shipping.tr(),
                              message: false),
                          _tabbar(
                              title: LocaleKeys.me_menu_complete_shop.tr(),
                              message: false),
                          _tabbar(
                              title: LocaleKeys.me_menu_cancel.tr(),
                              message: false),
                          // _tabbar(
                          //     title: LocaleKeys.me_menu_refund.tr(),
                          //     message: false),
                        ],
                      ),
                    ),
                  ),

                  // create widgets for each tab bar here
                  Expanded(
                    child: TabBarView(
                      children: [
                        PaidView(typeView: OrderViewType.Shop),
                        ShippedView(typeView: OrderViewType.Shop),
                        DeliveryView(typeView: OrderViewType.Shop),
                        SuccessView(typeView: OrderViewType.Shop),
                        CanceledView(typeView: OrderViewType.Shop),
                        // RefundView(typeView: OrderViewType.Shop)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabbar({String title, bool message}) {
    return Tab(
      child: Container(
        margin: EdgeInsets.only(
            left: SizeUtil.paddingEdittext().w, right: SizeUtil.paddingEdittext().w),
        child: Row(
          children: [
            Text(title,
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleSmallFontSize().sp)),
            SizedBox(
              width: message
                  ?2.0.w:0,
            ),
            message
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(9.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: 2.0.w,
                      height: 2.0.w,
                      color: ThemeColor.colorSale(),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

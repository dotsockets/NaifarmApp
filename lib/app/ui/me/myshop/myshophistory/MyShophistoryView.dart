
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/paid/PaidView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/refund/RefundView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/shipped/ShippedView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/success/SuccessView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
import 'package:sizer/sizer.dart';
import 'canceled/CanceledView.dart';
import 'delivery/DeliveryView.dart';



class MyShophistoryView extends StatelessWidget {
  int tab_count = 6;
  final int index;
  MyShophistoryView({Key key,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tab_count,
      initialIndex: index,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppToobar(
          title: LocaleKeys.me_title_history_shop.tr(),
          header_type: Header_Type.barNormal,
          icon: '',
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      indicator: MD2Indicator(
                        indicatorSize: MD2IndicatorSize.tiny,
                        indicatorHeight: 5.0,
                        indicatorColor: ThemeColor.ColorSale(),
                      ),
                      isScrollable: true,

                      tabs: [
                        _tabbar(title: LocaleKeys.me_menu_pay.tr(),message: false),
                        _tabbar(title: LocaleKeys.me_menu_ship.tr(),message: true),
                        _tabbar(title: LocaleKeys.me_menu_receive_shop.tr(),message: true),
                        _tabbar(title: LocaleKeys.me_menu_complete_shop.tr(),message: false),
                        _tabbar(title: LocaleKeys.me_menu_cancel.tr(),message: false),
                        _tabbar(title: LocaleKeys.me_menu_refund.tr(),message: false),
                      ],
                    ),
                  ),
                ),

                // create widgets for each tab bar here
                Expanded(
                  child: TabBarView(
                    children: [
                      PaidView(),
                      ShippedView(),
                      DeliveryView(),
                      SuccessView(),
                      CanceledView(),
                      RefundView()
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

  Widget _tabbar({String title,bool message}){
    return Tab(
      child: Row(
        children: [
          Text(title,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp)),
          SizedBox(width: 10,),
          message?ClipRRect(
            borderRadius: BorderRadius.circular(9.0),
            child: Container(
              alignment: Alignment.center,
              width: 10,
              height: 10,
              color: ThemeColor.ColorSale(),
            ),
          ):SizedBox()
        ],
      ),
    );
  }
}

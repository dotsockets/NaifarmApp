import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/paid/PaidView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/refund/RefundView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/shipped/ShippedView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/success/SuccessView.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
import 'package:sizer/sizer.dart';
import 'canceled/CanceledView.dart';
import 'delivery/DeliveryView.dart';

class MyOrderHistoryView extends StatelessWidget {
  final int index;
  final bool callback ;

  MyOrderHistoryView({Key key, this.index, this.callback}) : super(key: key);

  int tab_count = 6;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tab_count,
      initialIndex: index,
      child: Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppToobar(
              title: LocaleKeys.me_title_history.tr(),
              header_type: Header_Type.barcartShop,
              icon: '',onClick: (){
                if(callback){
                  AppRoute.PoppageCount(context: context,countpage: 4);
                }else{
                  AppRoute.PoppageCount(context: context,countpage: 1);
                }
            },
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 7.0.h,
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        indicator: MD2Indicator(
                          indicatorSize: MD2IndicatorSize.tiny,
                          indicatorHeight: 0.8.h,
                          indicatorColor: ThemeColor.ColorSale(),
                        ),
                        isScrollable: true,
                        tabs: [
                          _tabbar(
                              title: LocaleKeys.me_menu_pay.tr(), message: false),
                          _tabbar(
                              title: LocaleKeys.me_menu_ship.tr(), message: true),
                          _tabbar(
                              title: "ที่ต้องได้รับ",
                              message: true),
                          _tabbar(
                              title: "จัดส่งสำเร็จ",
                              message: false),
                          _tabbar(
                              title: LocaleKeys.me_menu_cancel.tr(),
                              message: false),
                          _tabbar(
                              title: LocaleKeys.me_menu_refund.tr(),
                              message: false),
                        ],
                      ),
                    ),
                  ),

                  // create widgets for each tab bar here
                  Expanded(
                    child:TabBarView(
                      children: [
                        PaidView(typeView: OrderViewType.Purchase,),
                        ShippedView(typeView: OrderViewType.Purchase,),
                        DeliveryView(typeView: OrderViewType.Purchase,),
                        SuccessView(typeView: OrderViewType.Purchase,),
                        CanceledView(typeView: OrderViewType.Purchase,),
                        RefundView(typeView: OrderViewType.Purchase,)
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
      child: Row(
        children: [
          Text(title,
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp)),
          SizedBox(
            width: 2.0.w,
          ),
          message
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 2.0.w,
                    height: 2.0.w,
                    color: ThemeColor.ColorSale(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

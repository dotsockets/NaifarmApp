
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/paid/PaidView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/refund/RefundView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/shipped/ShippedView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/success/SuccessView.dart';
import 'package:naifarm/app/ui/shopmain/category/CaregoryShopView.dart';
import 'package:naifarm/app/ui/shopmain/shop/Shop.dart';
import 'package:naifarm/app/ui/shopmain/shopdetails/ShopDetailsView.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';

import 'canceled/CanceledView.dart';
import 'delivery/DeliveryView.dart';



class MyShophistoryView extends StatelessWidget {
  int tab_count = 6;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tab_count,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppToobar(
          Title: "ประวัติการขาย",
          header_type: Header_Type.barNormal,
          icon: '',
          onClick: () {},
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
                        _tabbar(title: "ที่ต้องชำระ",message: false),
                        _tabbar(title: "ที่ต้องจัดส่ง",message: true),
                        _tabbar(title: "จัดส่ง",message: true),
                        _tabbar(title: "สำเร็จ",message: false),
                        _tabbar(title: "ยกเลิกแล้ว",message: false),
                        _tabbar(title: "คืนเงิน/สินค้า",message: false),
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
          Text(title,style: GoogleFonts.sarabun(fontSize: 16)),
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

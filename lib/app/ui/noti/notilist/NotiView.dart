import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiCus.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiShop.dart';
import 'package:naifarm/app/ui/shopmain/category/CaregoryShopView.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//'assets/images/svg/cart_top.svg'



class NotiView extends StatefulWidget {
  final bool btnBack;

  const NotiView({Key key, this.btnBack = false}) : super(key: key);
  @override
  _NotiViewState createState() => _NotiViewState();
}

class _NotiViewState extends State<NotiView> with SingleTickerProviderStateMixin{


  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar:  AppToobar(showBackBtn: widget.btnBack,header_type: Header_Type.barNormal,icon: 'assets/images/svg/cart_top.svg',title: LocaleKeys.recommend_notification.tr(),),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                    <Widget>[

                      SizedBox(height: 2,),
                    ]
                ),
              ),
            ];
          },
          body: Container(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  width: 80.0.w,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: ThemeColor.primaryColor(),
                    ),
                    labelColor: Colors.white,
                    labelStyle: FunctionHelper.FontTheme(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeUtil.titleFontSize().sp),
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      // first tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Buyer notification',
                      ),

                      // second tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Alert seller',
                      ),
                    ],
                  ),
                ),
                // tab bar view here
                SizedBox(height: 5,),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // first tab bar view widget
                        NotiCus(scaffoldKey: _scaffoldKey,),

                        // second tab bar view widget
                        NotiShop(scaffoldKey: _scaffoldKey,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
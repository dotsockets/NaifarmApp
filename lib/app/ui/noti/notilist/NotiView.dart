import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/model/pojo/response/NotificationCombine.dart';
import 'package:naifarm/app/models/NotiModel.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiCus.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiShop.dart';
import 'package:naifarm/app/ui/shopmain/category/CaregoryShopView.dart';
import 'package:naifarm/app/viewmodels/NotiViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
import 'package:rxdart/subjects.dart';
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

class _NotiViewState extends State<NotiView>
    with SingleTickerProviderStateMixin {
  bool IsLogin = true;

  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NotiBloc bloc;
  final _reload = BehaviorSubject<bool>();
  bool fixload = true;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

  }

  init() {
    ISLogin();
    if (bloc == null) {
      bloc = NotiBloc(AppProvider.getApplication(context));

    }
    Usermanager().getUser().then((value) {
      if (value.token != null) {
        NaiFarmLocalStorage.getNowPage().then((data){
          if(data == 2){
            _reload.add(true);
            bloc.MarkAsReadNotifications(token: value.token,context: context);
          }
        });
      }
    });

  }

  void ISLogin() async => IsLogin = await Usermanager().isLogin();


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: IsLogin?StreamBuilder(
                stream: _reload.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return  NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return [
                                SliverList(
                                  delegate: SliverChildListDelegate(<Widget>[
                                    AppToobar(
                                      showBackBtn: widget.btnBack,
                                      header_type: Header_Type.barcartShop,
                                      icon: 'assets/images/svg/cart_top.svg',
                                      title: LocaleKeys.recommend_notification
                                          .tr(),
                                      onClick: (){
                                        NaiFarmLocalStorage.saveNowPage(0);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                  ]),
                                ),
                              ];
                            },
                            body: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: TabBar(
                                    controller: _tabController,
                                    indicator: MD2Indicator(
                                      indicatorSize: MD2IndicatorSize.normal,
                                      indicatorHeight: 0.5.h,
                                      indicatorColor: ThemeColor.ColorSale(),
                                    ),
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

                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // first tab bar view widget
                                        NotiCus(
                                          scaffoldKey: _scaffoldKey,
                                        ),

                                        // second tab bar view widget
                                        NotiShop(
                                          scaffoldKey: _scaffoldKey,
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              ],
                            ),
                          );
                  } else {
                    return SizedBox();
                  }
                }): LoginView(
              IsHeader: false,
              homeCallBack: (bool fix) {
                Usermanager().getUser().then((value){
                  bloc.MarkAsReadNotifications(token: value.token);
                  _reload.add(true);
                });
              },
            )),
      ),
    );
  }
}

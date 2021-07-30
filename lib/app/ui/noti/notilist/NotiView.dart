import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiCus.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiShop.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotiView extends StatefulWidget {
  final bool btnBack;

  const NotiView({Key key, this.btnBack = false}) : super(key: key);

  @override
  _NotiViewState createState() => _NotiViewState();
}

class _NotiViewState extends State<NotiView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NotiBloc bloc;
  final _reload = BehaviorSubject<bool>();
  bool fixload = true;
  String isLogin = "";

  init() {
    if (bloc == null) {
      bloc = NotiBloc(AppProvider.getApplication(context));
      bloc.onSuccess.listen((event) {
        customReCount();
      });
    }
   _getNoti();
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController.dispose();
    }
    _reload.close();
    super.dispose();
  }

  void customReCount() {
    Usermanager().getUser().then((value) {
      context
          .read<CustomerCountBloc>()
          .loadCustomerCount(context, token: value.token);
    });
  }

  void iSLogin() async => isLogin = await Usermanager().isToken();

  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(
        top: false,
        bottom: widget.btnBack,
        child: BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
          builder: (_, count) {
            iSLogin();
            if (isLogin!=null) {
              if (count is InfoCustomerLoaded) {
                //  CustomReCount();
                if (count.profileObjectCombine.myShopRespone != null) {
                  return DefaultTabController(
                      length: 2,
                      child: _content(
                          profileObjectCombine: count.profileObjectCombine));
                } else {
                  //_tabController = TabController(length: 1, vsync: this);
                  return DefaultTabController(
                      length: 1,
                      child: _content(
                          profileObjectCombine: count.profileObjectCombine));
                }
              } else {
                // NaiFarmLocalStorage.saveNowPage(2);
                return Center(
                  child: Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator(),
                );
              }
            } else {
              return LoginView(
                isHeader: false,
                homeCallBack: (bool fix) {
                  Usermanager().getUser().then((value) {
                    bloc.markAsReadNotifications(context, token: value.token);
                    //_reload.add(true);
                  });
                  Navigator.of(context).pop();
                },
              );
            }
          },
        ));
  }

  Widget _content({ProfileObjectCombine profileObjectCombine}) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(7.5.h),
          child: AppToobar(
            showBackBtn: widget.btnBack,
            headerType: Header_Type.barcartShop,
            icon: 'assets/images/png/cart_top.png',
            title: LocaleKeys.recommend_notification.tr(),
            onClick: () {
              NaiFarmLocalStorage.saveNowPage(0);
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: SizeUtil.tabBarHeight().h,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  indicator: MD2Indicator(
                    indicatorSize: MD2IndicatorSize.normal,
                    indicatorHeight: 0.5.h,
                    indicatorColor: ThemeColor.colorSale(),
                  ),
                  tabs: profileObjectCombine.myShopRespone != null
                      ? [
                          // first tab [you can add an icon using the icon property]
                          Tab(
                            child: Text(
                              LocaleKeys.noti_buyer.tr(),
                              style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                              ),
                            ),
                          ),

                          // second tab [you can add an icon using the icon property]
                          Tab(
                            child: Text(
                              LocaleKeys.noti_seller.tr(),
                              style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                              ),
                            ),
                          )
                        ]
                      : [
                          Tab(
                            child: Text(
                              LocaleKeys.noti_buyer.tr(),
                              style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            ),
            // tab bar view here

            Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: TabBarView(
                    controller: _tabController,
                    children: profileObjectCombine.myShopRespone != null
                        ? [
                            // first tab bar view widget
                            NotiCus(
                              btnBack: widget.btnBack,
                              scaffoldKey: _scaffoldKey,
                            ),

                            NotiShop(
                              btnBack: widget.btnBack,
                              scaffoldKey: _scaffoldKey,
                            )
                          ]
                        : [
                            NotiCus(
                              btnBack: widget.btnBack,
                              scaffoldKey: _scaffoldKey,
                            )
                          ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
  _getNoti(){

    Usermanager().getUser().then((value) {
      if (value.token != null) {
        NaiFarmLocalStorage.getNowPage().then((data) {
          if (data == 2) {
            //NaiFarmLocalStorage.saveNowPage(0);
            Future.delayed(const Duration(milliseconds: 2000), () {
              bloc.markAsReadNotifications(context, token: value.token);
            });
          }
        });
      }
    });
  }
}

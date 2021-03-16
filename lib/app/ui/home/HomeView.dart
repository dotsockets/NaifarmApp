import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryView.dart';
import 'package:naifarm/app/ui/me/MeView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/OneSignalCall.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, RouteAware {
  List<MenuModel> _menuViewModel;
  bool isLogin = true;
  final _selectedIndex = BehaviorSubject<int>();
  bool isDialogShowing = false;
  NotiBloc bloc;

  init() {
    if (bloc == null) {
      //Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));

      bloc = NotiBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getNowPage().then((value) {
        _selectedIndex.add(value);
        NaiFarmLocalStorage.saveNowPage(0);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _menuViewModel = MenuViewModel().getTabBarMenus();

    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      OneSignalCall.oneSignalReceivedHandler(context);
    }
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("Change dependencies!!!!");
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    // setState(() {});
  }

  @override
  build(BuildContext context) {
    init();

    return WillPopScope(
      onWillPop: () async {
        FunctionHelper.confirmDialog(context,
            message: LocaleKeys.dialog_message_exit.tr(), onClick: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }, onCancel: () {
          Navigator.pop(context, true);
        });
        return false;
      },
      child: DefaultTabController(
          length: _menuViewModel.length,
          child: Scaffold(
              //backgroundColor: Colors.transparent,
              extendBody: true,
              body: StreamBuilder(
                stream: _selectedIndex.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return IndexedStack(
                    index: snapshot.data,
                    children: [
                      RecommendView(
                          size: MediaQuery.of(context).size,
                          paddingBottom: MediaQuery.of(context).padding.bottom,
                          onClick: (int index) {
                            if (index == 2) {
                              NaiFarmLocalStorage.saveNowPage(index);
                              _selectedIndex.add(index);
                            }
                          }),
                      CategoryView(),
                      //MyCartView(BtnBack: false,),
                      NotiView(btnBack: false,),
                      SizedBox(),
                      MeView()
                    ],
                  );
                },
              ),
              bottomNavigationBar: StreamBuilder(
                stream: _selectedIndex.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Device.get().isPhone ? 0 : 1.5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 1.5,
                          spreadRadius: 0.5,
                        ),
                      ],
                      color: ThemeColor.primaryColor(),
                    ),
                    child: SafeArea(
                      child: CustomTabBar(
                        menuViewModel: _menuViewModel,
                        selectedIndex: snapshot.data,
                        onTap: (index) {
                          Usermanager().getUser().then((value) => context
                              .read<CustomerCountBloc>()
                              .loadCustomerCount(context, token: value.token));
                          NaiFarmLocalStorage.saveNowPage(index);
                          if (index == 3) {
                            Usermanager().getUser().then((value) {
                              if (value.token != null) {
                                AppRoute.myCart(context, true);
                              } else {
                                AppRoute.login(context,
                                    isCallBack: true, isHeader: true);
                              }
                            });
                          } else {
                            _selectedIndex.add(index);
                          }
                        },
                      ),
                    ),
                  );
                },
              ))),
    );
  }
}

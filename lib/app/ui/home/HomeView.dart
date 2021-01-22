
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
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
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

class HomeView extends StatelessWidget  {


  final _selectedIndex = BehaviorSubject<int>();

  NotiBloc bloc;

  init(BuildContext context) {
    if (bloc == null) {
      Usermanager().getUser().then((value) => context
          .read<CustomerCountBloc>()
          .loadCustomerCount(token: value.token));

      bloc = NotiBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getNowPage().then((value) {
        _selectedIndex.add(value);
        NaiFarmLocalStorage.saveNowPage(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);

    return WillPopScope(
        onWillPop: () => _onBackPressed(context),
      child: DefaultTabController(
          length: MenuViewModel().getTabBarMenus().length,
          child: Scaffold(
              body: StreamBuilder(
                stream: _selectedIndex.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return IndexedStack(
                    index: snapshot.data,
                    children: [
                      RecommendView(
                          size: MediaQuery.of(context).size,
                          paddingBottom: MediaQuery.of(context).padding.bottom),
                      CategoryView(),
                      //MyCartView(BtnBack: false,),
                      NotiView(),
                      MeView()
                    ],
                  );
                },
              ),
              bottomNavigationBar: StreamBuilder(
                stream: _selectedIndex.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                    child: Container(
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
                          menuViewModel: MenuViewModel().getTabBarMenus(),
                          selectedIndex: snapshot.data,
                          onTap: (index) {
                            Usermanager().getUser().then((value) => context
                                .read<CustomerCountBloc>()
                                .loadCustomerCount(token: value.token));
                            NaiFarmLocalStorage.saveNowPage(index);
                            if (index == 2) {
                              Usermanager().isLogin().then((value) async {
                                if (!value) {
                                  final result = await AppRoute.Login(context,
                                      IsCallBack: true);
                                } else {
                                  Usermanager().getUser().then((value) {
                                    bloc.MarkAsReadNotifications(
                                        token: value.token);
                                  });

                                  // AppRoute.MyCart(context, true);
                                  _selectedIndex.add(index);
                                }
                              });
                            } else {
                              _selectedIndex.add(index);
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ))),
    );
  }

   _onBackPressed(BuildContext context) {
    FunctionHelper.ConfirmDialog(context,message: "Do you want to exit an App",onClick: (){
      Platform.isAndroid?SystemNavigator.pop():exit(0);
    },onCancel: (){
      Navigator.pop(context, true);
    }) ;

  }


}

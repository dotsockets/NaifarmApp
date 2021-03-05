import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
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
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryView.dart';
import 'package:naifarm/app/ui/category/detail/CategoryDetailView.dart';
import 'package:naifarm/app/ui/me/MeView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/OneSignalCall.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, RouteAware {
  List<MenuModel> _menuViewModel;
  bool IsLogin = true;
  final _selectedIndex = BehaviorSubject<int>();
  bool _isDialogShowing = false;
  NotiBloc bloc;
  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
    // initConnectivity();
    _menuViewModel = MenuViewModel().getTabBarMenus();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    OneSignalCall.OneSignalReceivedHandler();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    init();

    return WillPopScope(
      onWillPop: () async {
        FunctionHelper.ConfirmDialog(context,
            message: "Do you want to exit an App", onClick: () {
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
                      NotiView(),
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

                           Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
                          NaiFarmLocalStorage.saveNowPage(index);
                          if (index == 3) {
                            Usermanager().getUser().then((value) {
                              if (value.token != null) {
                                AppRoute.MyCart(context, true);
                              } else {
                                AppRoute.Login(context,
                                    IsCallBack: true, IsHeader: true);
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

  //
  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initConnectivity() async {
  //   ConnectivityResult result = ConnectivityResult.none;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //
  //   return _updateConnectionStatus(result);
  // }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        if (_isDialogShowing) {
          _isDialogShowing = false;
          Navigator.of(context).pop();
        }
        break;
      case ConnectivityResult.none:
        _isDialogShowing = true;
        FunctionHelper.AlertDialogShop(context,
            title: "Error Network",
            message: "The Internet contract has crashed Please try again...!",
            showbtn: false,
            barrierDismissible: false);
        break;
      default:
        print('Failed to get connectivity.');
        //  setState(() => _connectionStatus = result.toString());
        // FunctionHelper.AlertDialogShop(context,title: "Error",message: 'Failed to get connectivity.');
        break;
    }
  }
}

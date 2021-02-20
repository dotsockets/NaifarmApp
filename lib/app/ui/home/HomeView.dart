import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
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
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryView.dart';
import 'package:naifarm/app/ui/category/detail/CategoryDetailView.dart';
import 'package:naifarm/app/ui/me/MeView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
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
    with SingleTickerProviderStateMixin {
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
      _menuViewModel = MenuViewModel().getTabBarMenus();
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
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    InitializeOneSignal();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> InitializeOneSignal() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(
        "YOUR_ONESIGNAL_APP_ID",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        }
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
     print("notification : ${notification}");
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      //(ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });

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
                      MeView()
                    ],
                  );
                },
              ),
              bottomNavigationBar: StreamBuilder(
                stream: _selectedIndex.stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Container(
                    height: 10.0.h,
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
                          // Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
                          NaiFarmLocalStorage.saveNowPage(index);
                          _selectedIndex.add(index);
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
          AppRoute.PoppageCount(context: context, countpage: 1);
        }
        break;
      case ConnectivityResult.none:
        _isDialogShowing = true;
        FunctionHelper.AlertDialogShop(context,
            title: "Error Network",
            message: "The Internet contract has crashed Please try again...!",
            showbtn: false,
            barrierDismissible: false);
        //  setState(() => _connectionStatus = result.toString());
        break;
      default:
        print('Failed to get connectivity.');
        // FunctionHelper.AlertDialogShop(context,title: "Error",message: 'Failed to get connectivity.');
        break;
    }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:naifarm/app/bloc/Provider/HomeMenuIndex.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryView.dart';
import 'package:naifarm/app/ui/me/MeView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/OneSignalCall.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:uni_links/uni_links.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, RouteAware {
  List<MenuModel> _menuViewModel;
  bool isLogin = true;
  //final _selectedIndex = BehaviorSubject<int>();
  bool isDialogShowing = false;
  ProductBloc bloc;
  StreamSubscription sub;
  Uri initialUri;
  String latestUri;
  Object err;
  bool initialUriIsHandled = true;

  init() {
    _handleIncomingLinks();
    _handleInitialUri();
    if (bloc == null) {
      //Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));

      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          //  FunctionHelper.SuccessDialog(context,message: "555");
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.productItem.stream.listen((item) {
        // bloc.onLoad.add(false);

        AppRoute.productDetail(context,
            productImage: "product_hot_${item.id}1", productItem: item);
      });

      NaiFarmLocalStorage.getNowPage().then((value) {
        if(value==3){
          context.read<HomeMenuIndex>().onSelect(0);
          AppRoute.myCart(context, true);


        }else{
          context.read<HomeMenuIndex>().onSelect(value);
        }

       // NaiFarmLocalStorage.saveNowPage(0);
      });
    }
  }

  void _handleIncomingLinks() {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    if (!kIsWeb) {
      sub = getLinksStream().listen((String link) {
        if (!mounted) return;
        // setState(() {
        //   _latestUri = link;
        //   _err = null;
        // });
        latestUri = link;
        err = null;
        if (link.split("-i.").length == 2) {
          bloc.getProductsByIdApplink(context,
              id: int.parse(link.split("-i.")[1]), onload: false);
        } else if (link.split("-cg.").length == 2) {
          AppRoute.categoryDetail(context, int.parse(link.split("-cg.")[1]),
              title: LocaleKeys.recommend_category_product.tr());
        } else if (link.split("-cs.").length == 2) {
          AppRoute.categorySubDetail(context, int.parse(link.split("-cs.")[1]),
              title: LocaleKeys.recommend_category_sub.tr());
        } else if (link.split("/")[3] == "special-price") {
          AppRoute.productMore(
              apiLink: "products/types/discount",
              context: context,
              barTxt: LocaleKeys.recommend_special_price_product.tr());
        } else if (link.split("/")[3] == "shop") {
          // context.read<HomeMenuIndex>().onSelect(1);
          AppRoute.shopMain(
              context: context, myShopRespone: MyShopRespone(id: 1));
        } else if (link.split("/")[3] == "category") {
          context.read<HomeMenuIndex>().onSelect(1);
        } else if (link.split("/")[3] == "notification") {
          context.read<HomeMenuIndex>().onSelect(2);
        } else if (link.split("/")[3] == "cart") {
          Usermanager().getUser().then((value) {
            if (value.token != null) {
              AppRoute.myCart(context, true);
            } else {
              AppRoute.login(context,
                  isCallBack: true, isHeader: true, isSetting: false);
            }
          });
        } else if (link.split("/")[3] == "member") {
          context.read<HomeMenuIndex>().onSelect(4);
        }
      }, onError: (Object err) {
        if (!mounted) return;
        latestUri = null;
        if (err is FormatException) {
          err = err;
        } else {
          err = null;
        }
      });
    }
  }

  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!initialUriIsHandled) {
      initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
        initialUri = uri;
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (ex) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => err = ex);
      }
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
    sub.cancel();
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
              body: BlocBuilder<HomeMenuIndex, int>(
                builder: (_, indexSelect) {
                  return IndexedStack(
                    index: indexSelect,
                    children: [
                      RecommendView(
                          size: MediaQuery.of(context).size,
                          paddingBottom: MediaQuery.of(context).padding.bottom,
                          onClick: (int index) {
                            if (index == 2) {
                              context.read<HomeMenuIndex>().onSelect(index);
                            }
                          }),
                      CategoryView(),
                      //MyCartView(BtnBack: false,),
                      NotiView(
                        btnBack: false,
                      ),
                      SizedBox(),
                      MeView()
                    ],
                  );
                },
              ),
              bottomNavigationBar: BlocBuilder<HomeMenuIndex, int>(
                builder: (_, indexSelect) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Device.get().isPhone ? 0 : 1.5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight:
                              Radius.circular(SizeUtil.borderRadiusFooter()),
                          topLeft:
                              Radius.circular(SizeUtil.borderRadiusFooter())),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                         // color: Color(0xFF254117).withOpacity(0.75),
                          color: Colors.black26,
                          blurRadius: 1.5,
                          spreadRadius: 0.5,
                          offset: Offset(0, -1),
                        ),
                      ],
                      color: ThemeColor.primaryColor(),
                    ),
                    child: SafeArea(
                      child: CustomTabBar(
                        menuViewModel: _menuViewModel,
                        selectedIndex: indexSelect,
                      ),
                    ),
                  );
                },
              ))),
    );
  }
}

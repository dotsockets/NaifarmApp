import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/ui/setting/guestSetting/SettingGuestView.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:rxdart/subjects.dart';
import 'myshop/MyshopView.dart';
import 'purchase/PurchaseView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class MeView extends StatefulWidget {
  @override
  _MeViewState createState() => _MeViewState();
}

class _MeViewState extends State<MeView> with RouteAware {
  MemberBloc bloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onDialog = true;
  StreamController<bool> controller = new StreamController<bool>();
  ScrollController _scrollController = ScrollController();
  final expandedBar = BehaviorSubject<bool>();
  final titleBar = BehaviorSubject<bool>();
  bool isLogin = true;

  void _init() {
    if (null == bloc) {
      expandedBar.add(false);
      titleBar.add(false);
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        // FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });

      //_reload.stream.listen((event) {
      // Usermanager().getUser().then((value) => context
      //     .read<CustomerCountBloc>()
      //     .loadCustomerCount(token: value.token));
      //Usermanager().getUser().then((value) => bloc.loadMyProfile(token: value.token));
      // });

      // Usermanager().getUser().then((value) {
      //   if (value.token != null) {
      //     _reload.add(true);
      //   } else {
      //     _reload.add(false);
      //   }
      // });

    }

    // NaiFarmLocalStorage.getNowPage().then((data) {
    //         if (data == 4) {
    //           // OneSignalCall.cancelNotification("meView", 0);
    //         }
    //       });

    _scrollController.addListener(() {
      if (_isAppBarExpanded) {
        expandedBar.add(true);
      } else {
        expandedBar.add(false);
      }

      if (_scrollController.hasClients &&
          _scrollController.offset > (100 - kToolbarHeight)) {
        titleBar.add(true);
      } else {
        titleBar.add(false);
      }
    });
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  void iSLogin() async => isLogin = await Usermanager().isLogin();

  @override
  Widget build(BuildContext context) {
    _init();
    return BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
      builder: (_, count) {
        iSLogin();
        if (isLogin) {
          if (count is InfoCustomerLoaded || count is InfoCustomerLoading) {
            return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.grey.shade300,
                body: _contentMe());
          } else if (count is InfoCustomerError) {
            return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.grey.shade300,
                body: _contentMe());
          } else {
            return Center(
              child: Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator(),
            );
          }
        } else {
          // return LoginView(
          //   isHeader: false,
          //   homeCallBack: (bool fix) {
          //     isLogin = fix;
          //     Navigator.of(context).pop();
          //   },
          // );
          return SettingGuestView(
              isHeader: false,
              logincall: (index) {
                isLogin = index;
              });
        }
      },
    );
  }

  Widget _contentMe() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          toolbarHeight: 5.5.h,
          leading: Container(
            margin: EdgeInsets.only(left: 1.0.w, top: SizeUtil.paddingItem().w),
            child: IconButton(
              icon: Icon(Icons.settings,
                  color: Colors.white, size: SizeUtil.iconLargeSize().w),
              onPressed: () async {
                // ignore: unused_local_variable
                final result = await AppRoute.settingProfile(context);
                isLogin = false;
              },
            ),
          ),
          title: StreamBuilder(
            stream: titleBar.stream,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return !snapshot.data
                    ? Container(
                        margin: EdgeInsets.only(top: SizeUtil.paddingItem().w),
                        child: Center(
                          child: Text("${LocaleKeys.me_account.tr()}",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      )
                    : SizedBox();
              } else {
                return SizedBox();
              }
            },
          ),
          centerTitle: true,
          actions: [
            Container(
                margin: EdgeInsets.only(
                    right: 2.0.w, left: 1.0.w, top: SizeUtil.paddingItem().w),
                child: StreamBuilder(
                  stream: expandedBar.stream,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return !snapshot.data ? BuildIconShop() : SizedBox();
                    } else {
                      return SizedBox();
                    }
                  },
                )),
          ],
          expandedHeight: SizeUtil.headerHeight().h,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: ThemeColor.primaryColor(),
              child: BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
                builder: (_, item) {
                  if (item is InfoCustomerLoaded) {
                    return _imageHeader(
                        info: item.profileObjectCombine.customerInfoRespone);
                  } else if (item is InfoCustomerLoading) {
                    return _imageHeader(
                        info: item.profileObjectCombine != null
                            ? item.profileObjectCombine.customerInfoRespone
                            : []);
                  } else if (item is InfoCustomerError) {
                    return _imageHeader(
                        info: item.profileObjectCombine.customerInfoRespone);
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
              builder: (_, item) {
                if (item is InfoCustomerLoaded) {
                  if (item.profileObjectCombine.shppingMyShopRespone.data
                      .isNotEmpty) {
                    return bodyContent(
                        wigitHight: item
                                    .profileObjectCombine
                                    .shppingMyShopRespone
                                    .data[0]
                                    .rates
                                    .length ==
                                0
                            ? 100.0.h
                            : 90.0.h);
                  } else {
                    return bodyContent(wigitHight: 80.0.h);
                  }
                } else if (item is InfoCustomerLoading) {
                  return bodyContent(wigitHight: 80.0.h);
                } else if (item is InfoCustomerError) {
                  if (item.profileObjectCombine.shppingMyShopRespone.data
                      .isNotEmpty) {
                    return bodyContent(
                        wigitHight: item
                                    .profileObjectCombine
                                    .shppingMyShopRespone
                                    .data[0]
                                    .rates
                                    .length ==
                                0
                            ? 100.0.h
                            : 90.0.h);
                  } else {
                    return bodyContent(wigitHight: 80.0.h);
                  }
                } else {
                  return SizedBox();
                }
              },
            )
          ]),
        )
      ],
    );
  }

  Widget bodyContent({double wigitHight}) {
    return Container(
      height: SizeUtil.meBodyHeight(wigitHight),
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Container(
          child: Column(
            children: <Widget>[
              // BlocBuilder<CustomerCountBloc, CustomerCountRespone>(
              //   builder: (_, count) {
              //     return Center(
              //       child: Text('${count.like}', style: Theme.of(context).textTheme.headline1),
              //     );
              //   },
              // ),
              SizedBox(
                height: SizeUtil.tabBarHeight().h,
                child: Container(
                  // color: ThemeColor.psrimaryColor(context),
                  child: TabBar(
                    indicatorColor: ThemeColor.colorSale(),
                    /* indicator: MD2Indicator(
                                  indicatorSize: MD2IndicatorSize.tiny,
                                  indicatorHeight: 5.0,
                                  indicatorColor: ThemeColor.colorSale(),
                                ),*/
                    isScrollable: false,
                    tabs: [
                      _tabbar(
                          title: LocaleKeys.me_tab_buy.tr(), message: false),
                      _tabbar(
                          title: LocaleKeys.me_tab_shop.tr(), message: false)
                    ],
                  ),
                ),
              ),

              // create widgets for each tab bar here
              Expanded(
                child: TabBarView(
                  children: [
                    PurchaseView(
                      onStatus: (bool status) {
                        if (status) {
                          if (status) {
                            // _reload.add(true);
                            isLogin = false;
                          }
                        }
                      },
                    ),
                    MyshopView(
                      scaffoldKey: _scaffoldKey,
                      onStatus: (bool status) {
                        if (status) {
                          Future.delayed(const Duration(milliseconds: 300), () {
                            Usermanager().getUser().then((value) => context
                                .read<CustomerCountBloc>()
                                .loadCustomerCount(context,
                                    token: value.token));
                            Usermanager().getUser().then((value) => context
                                .read<InfoCustomerBloc>()
                                .loadCustomInfo(context, token: value.token));
                          });
                          // Usermanager()
                          //     .getUser()
                          //     .then((value) =>
                          //     bloc.loadMyProfile(
                          //         token: value.token));
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageHeader({CustomerInfoRespone info}) {
    return info != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 7.0.h,
              ),
              InkWell(
                  child:
                      /*Hero(
                    tag: "image_profile_me",
                    child:*/
                      Hero(
                        tag: "image_profile_me",
                        child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0.w)),
                    child: CachedNetworkImage(
                        width: SizeUtil.imgProfileSize().w,
                        height: SizeUtil.imgProfileSize().w,
                        placeholder: (context, url) => Container(
                          width: SizeUtil.imgProfileSize().w,
                          height: SizeUtil.imgProfileSize().w,
                          color: Colors.white,
                          child: Lottie.asset(
                            'assets/json/loading.json',
                            height: SizeUtil.imgProfileSize().w,
                            width: SizeUtil.imgProfileSize().w,
                          ),
                        ),
                        fit: BoxFit.cover,
                        imageUrl: info != null
                            ? info.image.length > 0
                                ? "${Env.value.baseUrl}/storage/images/${info.image[0].path}"
                                : ''
                            : '',
                        errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade300,
                            width: SizeUtil.imgProfileSize().w,
                            height: SizeUtil.imgProfileSize().w,
                            child: Icon(
                              Icons.person,
                              size: SizeUtil.iconSize().w,
                              color: Colors.white,
                            )),
                    ),
                  ),
                      ),
                  //),
                  onTap: () {
                    AppRoute.imageFullScreenView(
                        heroTag: "image_profile_me",
                        context: context,
                        imgList: covertImgShop(info.image));

                  }),
              SizedBox(height: 2.0.h),
              Text(info != null ? info.name : "ฟาร์มมาร์เก็ต",
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.bold))
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 3.0.h,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                child: Container(
                  width: 20.0.w,
                  height: 20.0.w,
                  color: Colors.white,
                  child: Lottie.asset('assets/json/loading.json', height: 30),
                ),
              ),
              SizedBox(height: 2.0.h),
              Text(
                  info != null
                      ? info.name
                      : LocaleKeys.dialog_message_loading.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.bold))
            ],
          );
  }

  // Widget _FormLogin() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         height: 30,
  //       ),
  //       Container(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             FlatButton(
  //               minWidth: 40.0.w,
  //               color: ThemeColor.colorSale(),
  //               textColor: Colors.white,
  //               splashColor: Colors.white.withOpacity(0.3),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(40.0),
  //               ),
  //               onPressed: () async {
  //                 NaiFarmLocalStorage.saveNowPage(3);
  //                 final result =
  //                     await AppRoute.Login(context, IsCallBack: true);
  //                 if (result) {
  //                   // Usermanager().getUser().then(
  //                   //     (value){
  //                   //       bloc.loadMyProfile(token: value.token);
  //                   //     });
  //                 } else {
  //                   NaiFarmLocalStorage.saveNowPage(0);
  //                 }
  //               },
  //               child: Text(
  //                 LocaleKeys.login_btn.tr(),
  //                 style: FunctionHelper.fontTheme(
  //                     fontSize: SizeUtil.titleFontSize().sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             FlatButton(
  //               minWidth: 40.0.w,
  //               color: ThemeColor.secondaryColor(),
  //               textColor: Colors.white,
  //               splashColor: Colors.white.withOpacity(0.3),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(40.0),
  //               ),
  //               onPressed: () async {
  //                 AppRoute.Register(context);
  //               },
  //               child: Text(
  //                 LocaleKeys.register_btn.tr(),
  //                 style: FunctionHelper.fontTheme(
  //                     fontSize: SizeUtil.titleFontSize().sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //             )
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _tabbar({String title, bool message}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: FunctionHelper.fontTheme(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: Colors.black)),
          SizedBox(
            width: 20,
          ),
          message
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 10,
                    height: 20,
                    color: ThemeColor.colorSale(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
  List<String> covertImgShop(List<ImageShop> image) {
    List<String> imageList = <String>[];
    if (image.length != 0) {
      imageList.add("${Env.value.baseUrl}/storage/images/${image[0].path}");
    }else{
      imageList.add("");
    }
    return imageList;
  }
}

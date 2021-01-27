import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
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
  bool IsLogin = true;

  MemberBloc bloc;
  final _reload = BehaviorSubject<bool>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  StreamController<bool> controller = new StreamController<bool>();

  void _init() {
    if (null == bloc) {
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        // if(event){
        //   FunctionHelper.showDialogProcess(context);
        // }else{
        //   Navigator.of(context).pop();
        // }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        // FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });

     _reload.stream.listen((event) {
       Usermanager().getUser().then((value) =>
           context
               .read<CustomerCountBloc>()
               .loadCustomerCount(
               token: value.token));
         Usermanager().getUser().then((value) => bloc.loadMyProfile(token: value.token));

     });

      Usermanager().getUser().then((value) {
        if (value.token != null) {
          _reload.add(true);
        } else {
          _reload.add(false);
        }
      });

    }

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Builder(
          builder: (context) {
            // final _scr = PrimaryScrollController.of(context);
            // _scr.addListener(() {
            //   if (_scr.position.pixels > 100) {
            //     controller.add(false);
            //   } else {
            //     controller.add(true);
            //   }
            // });
            return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.grey.shade300,
                body: StreamBuilder(
                    stream: _reload.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data
                            ? StreamBuilder(
                                stream: bloc.customerInfoRespone.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    var info =
                                        (snapshot.data as ProfileObjectCombine);

                                    return CustomScrollView(
                                      // controller: _scr,
                                      slivers: [
                                        SliverAppBar(
                                          leading: Container(
                                            margin: EdgeInsets.only(
                                                left: 1.0.w),
                                            child: GestureDetector(
                                              child: IconButton(
                                                icon: Icon(Icons.settings,
                                                    color: Colors.white,
                                                    size: 6.0.w),
                                              ),
                                              onTap: () async {
                                                final result = await AppRoute
                                                    .SettingProfile(
                                                        context, IsLogin,
                                                        item: info
                                                            .customerInfoRespone);
                                                if (result != null && result) {
                                                  _reload.add(true);
                                                }
                                              },
                                            ),
                                          ),
                                          actions: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    right: 2.0.w, top: 1.0.w),
                                                child:  BuildIconShop(
                                                  size: 6.0.w,
                                                )),
                                          ],
                                          expandedHeight: 200,
                                          flexibleSpace: FlexibleSpaceBar(
                                            background: Container(
                                              color: ThemeColor.primaryColor(),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 3.0.h,
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                60)),
                                                    child: CachedNetworkImage(
                                                      width: 20.0.w,
                                                      height: 20.0.w,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                                width: 20.0.w,
                                                                height: 20.0.w,
                                                        color: Colors.white,
                                                        child: Lottie.asset(
                                                            Env.value
                                                                .loadingAnimaion,
                                                            height: 30),
                                                      ),
                                                      fit: BoxFit.cover,
                                                      imageUrl: info
                                                                  .customerInfoRespone !=
                                                              null
                                                          ? info.customerInfoRespone
                                                                      .image.length >
                                                                  0
                                                              ? "${Env.value.baseUrl}/storage/images/${info.customerInfoRespone.image[0].path}"
                                                              : ''
                                                          : '',
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                              color: Colors.grey
                                                                  .shade300,
                                                              width: 20.0.w,
                                                              height: 20.0.w,
                                                              child: Icon(
                                                                Icons.person,
                                                                size: 10.0.w,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.0.h),
                                                  Text(
                                                      info.customerInfoRespone !=
                                                              null
                                                          ? info
                                                              .customerInfoRespone
                                                              .name
                                                          : "ฟาร์มมาร์เก็ต",
                                                      style: FunctionHelper
                                                          .FontTheme(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: SizeUtil
                                                                      .titleFontSize()
                                                                  .sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SliverList(
                                          delegate:
                                              SliverChildListDelegate(<Widget>[
                                            Container(
                                              height: 180.0.w,
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
                                                        height: 7.0.h,
                                                        child: Container(
                                                          // color: ThemeColor.psrimaryColor(context),
                                                          child: TabBar(
                                                            indicatorColor:
                                                                ThemeColor
                                                                    .ColorSale(),
                                                            /* indicator: MD2Indicator(
                                  indicatorSize: MD2IndicatorSize.tiny,
                                  indicatorHeight: 5.0,
                                  indicatorColor: ThemeColor.ColorSale(),
                                ),*/
                                                            isScrollable: false,
                                                            tabs: [
                                                              _tabbar(
                                                                  title: LocaleKeys
                                                                      .me_tab_buy
                                                                      .tr(),
                                                                  message:
                                                                      false),
                                                              _tabbar(
                                                                  title: LocaleKeys
                                                                      .me_tab_shop
                                                                      .tr(),
                                                                  message:
                                                                      false)
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      // create widgets for each tab bar here
                                                      Expanded(
                                                        child: TabBarView(
                                                          children: [
                                                            PurchaseView(
                                                              IsLogin: IsLogin,
                                                              item: info
                                                                  .customerInfoRespone,
                                                              onStatus: (bool
                                                                  status) {
                                                                if (status) {
                                                                  Usermanager()
                                                                      .getUser()
                                                                      .then((value) =>
                                                                          bloc.loadMyProfile(
                                                                              token: value.token));
                                                                }
                                                              },
                                                            ),
                                                            MyshopView(
                                                              IsLogin: IsLogin,
                                                              scaffoldKey:
                                                                  _scaffoldKey,
                                                              customerInfoRespone:
                                                                  info.customerInfoRespone,
                                                              myShopRespone: info
                                                                  .myShopRespone,
                                                              onStatus: (bool
                                                                  status) {
                                                                if (status) {
                                                                  Usermanager()
                                                                      .getUser()
                                                                      .then((value) =>
                                                                          bloc.loadMyProfile(
                                                                              token: value.token));
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
                                            )
                                          ]),
                                        )
                                      ],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                              )
                            : LoginView(
                                IsHeader: false,
                                homeCallBack: (bool fix) {
                                  _reload.add(true);
                                },
                              );
                      } else {
                        return SizedBox();
                      }
                    }));
          },
        ),
      ),
    );
  }

  Widget _FormLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                minWidth: 40.0.w,
                color: ThemeColor.ColorSale(),
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: () async {
                  NaiFarmLocalStorage.saveNowPage(3);
                  final result =
                      await AppRoute.Login(context, IsCallBack: true);
                  if (result) {
                    // Usermanager().getUser().then(
                    //     (value){
                    //       bloc.loadMyProfile(token: value.token);
                    //     });
                  } else {
                    NaiFarmLocalStorage.saveNowPage(0);
                  }
                },
                child: Text(
                  LocaleKeys.login_btn.tr(),
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              FlatButton(
                minWidth: 40.0.w,
                color: ThemeColor.secondaryColor(),
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: () async {
                  AppRoute.Register(context);
                },
                child: Text(
                  LocaleKeys.register_btn.tr(),
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _tabbar({String title, bool message}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: FunctionHelper.FontTheme(
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
                    color: ThemeColor.ColorSale(),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

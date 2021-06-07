import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';
import 'package:naifarm/app/ui/shopmain/shop/Shop.dart';
import 'package:naifarm/app/ui/shopmain/shopdetails/ShopDetailsView.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ShopOwn.dart';
import 'package:sizer/sizer.dart';
import '../../../utility/widgets/MD2Indicator.dart';
import 'category/CaregoryShopView.dart';

class ShopMainView extends StatefulWidget {
  final MyShopRespone myShopRespone;

  const ShopMainView({Key key, this.myShopRespone}) : super(key: key);

  @override
  _ShopMainViewState createState() => _ShopMainViewState();
}

class _ShopMainViewState extends State<ShopMainView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  ProductBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.zipShopObject
          .add(ZipShopObjectCombin(shopRespone: widget.myShopRespone));

      NaiFarmLocalStorage.getNaiFarmShopCache().then((value) {
        if (value != null) {
          for (var data in value.item) {
            if (data.shopRespone != null &&
                data.shopRespone.id == widget.myShopRespone.id) {
              bloc.zipShopObject.add(data);
              break;
            }
          }
        }
        Usermanager().getUser().then((value) => bloc.loadShop(context,
            shopid: widget.myShopRespone.id, token: value.token));
      });

      bloc.onError.stream.listen((event) {
        if (event.status == 0 || event.status >= 500) {
          Future.delayed(const Duration(milliseconds: 300), () {
            FunctionHelper.alertDialogRetry(context,
                cancalMessage: LocaleKeys.btn_exit.tr(),
                callCancle: () {
                  AppRoute.poppageCount(context: context, countpage:2);
                },
                title: LocaleKeys.btn_error.tr(),
                message: event.message,
                callBack: () {
                  NaiFarmLocalStorage.getNaiFarmShopCache().then((value) {
                    if (value != null) {
                      Usermanager().getUser().then((value) => bloc.loadShop(
                          context,
                          shopid: widget.myShopRespone.id,
                          token: value.token));
                    }
                  });
                });
          });
        }
      });

      // bloc.onError.stream.listen((event) {
      //   print("ewfcewrfc ${event.error}");
      // });
    }
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      initialIndex: selectedIndex,
      length: 3,
      vsync: this,
    );

    tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        selectedIndex = tabController.index;
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.0.h),
              child: AppToobar(
                title: LocaleKeys.shop_title.tr(),
                headerType: Header_Type.barcartShop,
                icon: 'assets/images/png/search.png',
              ),
            ),
            backgroundColor: Colors.white,
            body: StreamBuilder(
              stream: bloc.onError.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return _content;
              },
            )),
      ),
    );
  }

  Widget get _content => StreamBuilder(
      stream: bloc.zipShopObject.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var item = (snapshot.data as ZipShopObjectCombin);
        if (snapshot.hasData && item.productmyshop != null) {
          return SafeArea(
            child: Container(
              color: Colors.grey.shade300,
              child: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          ShopOwn(
                            rateStyle: false,
                            showBtn: false,
                            shopItem: ShopItem(
                                countProduct: item.productmyshop.total,
                                name: item.shopRespone.name,
                                id: item.shopRespone.id,
                                image: item.shopRespone.image,
                                updatedAt: item.shopRespone.updatedAt,
                                state: item.shopRespone.state),
                            shopRespone: item.shopRespone,
                          )
                        ]),
                      ),
                    ];
                  },
                  body: Column(
                    children: <Widget>[
                      SizedBox(
                        height: SizeUtil.tabBarHeight().h,
                        child: Container(
                          color: Colors.white,
                          child: TabBar(
                            indicator: MD2Indicator(
                              indicatorSize: MD2IndicatorSize.tiny,
                              indicatorHeight: 5.0,
                              indicatorColor: ThemeColor.primaryColor(),
                            ),
                            controller: tabController,
                            tabs: [
                              _tabbar(
                                  title: LocaleKeys.shop_title.tr(), index: 0),
                              _tabbar(
                                  title: LocaleKeys.shop_category.tr(),
                                  index: 1),
                              _tabbar(
                                  title: LocaleKeys.shop_detail.tr(), index: 2),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Shop(
                                productRespone:
                                    (snapshot.data as ZipShopObjectCombin)),
                            CaregoryShopView(
                                shopId: widget.myShopRespone.id,
                                categoryGroupRespone:
                                    (snapshot.data as ZipShopObjectCombin)
                                        .categoryGroupRespone),
                            ShopDetailsView(
                              zipShopObjectCombin:
                                  (snapshot.data as ZipShopObjectCombin),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: Center(
                    child: Platform.isAndroid
                        ? CircularProgressIndicator()
                        : CupertinoActivityIndicator()),
              )
            ],
          );
        }
      });

  Widget _tabbar({String title, int index}) {
    return Tab(
      child: Container(
        child: Text(title,
            style: FunctionHelper.fontTheme(
                fontWeight: FontWeight.w500,
                fontSize: SizeUtil.titleSmallFontSize().sp,
                color: tabController.index == index
                    ? Colors.black
                    : Colors.grey.shade700)),
      ),
    );
  }
}

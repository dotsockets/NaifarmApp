import 'dart:io';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/widgets/HistoryProductCard.dart';
import 'package:sizer/sizer.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

class SuccessView extends StatefulWidget {
  final OrderViewType typeView;

  const SuccessView({Key key, this.typeView}) : super(key: key);

  @override
  _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView>   {
  OrdersBloc bloc;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int limit = 10;
  bool stepPage = false;
  final _indicatorController = IndicatorController();

  ProductBloc productBloc;

  init() {
    if (bloc == null && productBloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      productBloc = ProductBloc(AppProvider.getApplication(context));

      NaiFarmLocalStorage.getHistoryCache().then((value) {
        //   print("ewfcwef ${value}");
        String orderType =
            widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order";
        if (value != null) {
          for (var data in value.historyCache) {
            if (data.orderViewType == orderType && data.typeView == "6") {
              bloc.orderDataList.addAll(data.orderRespone.data);
              bloc.onSuccess.add(OrderRespone(
                  data: bloc.orderDataList,
                  total: data.orderRespone.total,
                  limit: data.orderRespone.limit,
                  page: data.orderRespone.limit));
              break;
            }
          }
        }
        Usermanager().getUser().then((value) => bloc.loadOrder(context,
            orderType: widget.typeView == OrderViewType.Shop
                ? "myshop/orders"
                : "order",
            statusId: "6",
            sort: "orders.updatedAt:desc",
            limit: limit,
            page: 1,
            token: value.token));
      });
    }
    productBloc.onError.stream.listen((event) {
      //Navigator.of(context).pop();
      FunctionHelper.alertDialogShop(context,
          message: event.message,
          showbtn: true,
          title: LocaleKeys.btn_error.tr());
      //FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
    });

    productBloc.onLoad.stream.listen((event) {
      if (event) {
        FunctionHelper.showDialogProcess(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    productBloc.onSuccess.stream.listen((event) {
      //onUpload = true;
      if (event is CartResponse) {

        AppRoute.myCart(context, true, cartNowId: productBloc.bayNow);
        // Usermanager().getUser().then((value) => bloc.GetMyWishlistsById(token: value.token,productId: widget.productItem.id));
      }
    });
    bloc.onError.stream.listen((msg) {
      Future.delayed(const Duration(milliseconds: 300), () {
        FunctionHelper.alertDialogRetry(context,
            cancalMessage: LocaleKeys.btn_exit.tr(),
            callCancle: () {
              if ((msg as ThrowIfNoSuccess).status == 406) {
                Navigator.of(context).pop();
              } else {
                AppRoute.poppageCount(context: context, countpage: 2);
              }
            },
            title: LocaleKeys.btn_error.tr(),
            message: (msg as ThrowIfNoSuccess).message,
            callBack: () {
              Usermanager().getUser().then((value) => bloc.loadOrder(context,
                  orderType: widget.typeView == OrderViewType.Shop
                      ? "myshop/orders"
                      : "order",
                  statusId: "6",
                  sort: "orders.updatedAt:desc",
                  limit: limit,
                  page: 1,
                  token: value.token));
            });
      });
    });

    bloc.orderList.stream.listen((event) {
      if(event is OrderData){
        List<Items> items = <Items>[];
        for (var value in event.items) {
          items.add(Items(
              inventoryId: value.inventoryId, quantity: value.quantity));
        }

        Usermanager()
            .getUser()
            .then((value) => productBloc.addCartlists(context,
            cartRequest: CartRequest(
              shopId: event.shop.id,
              items: items,
            ),
            token: value.token));
      }

    });


    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
          page++;
          _reloadData();
        }
      }
    });
  }



  @override
  void didPopNext() {
    if(mounted){
      Usermanager().getUser().then((value) => bloc.loadOrder(context,
          orderType: widget.typeView == OrderViewType.Shop
              ? "myshop/orders"
              : "order",
          statusId: "6",
          sort: "orders.updatedAt:desc",
          limit: limit,
          page: 1,
          token: value.token));
    }
  }

  Widget androidRefreshIndicator() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: mainContent(),
    );
  }

  Widget iosRefreshIndicator() {
    return CustomRefreshIndicator(
        controller: _indicatorController,
        onRefresh: () => onRefresh(),
        armedToLoadingDuration: const Duration(seconds: 1),
        draggingToIdleDuration: const Duration(seconds: 1),
        completeStateDuration: const Duration(seconds: 1),
        offsetToArmed: 50.0,
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget _) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      bloc.onSuccess.value != null
                          ? Positioned(
                              top: 25 * controller.value,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: 1.5.h, bottom: 1.0.h),
                                  child: CupertinoActivityIndicator()),
                            )
                          : SizedBox()
                    ],
                  );
                },
              ),
              AnimatedBuilder(
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(
                        0.0, controller.value * SizeUtil.indicatorSize()),
                    child: child,
                  );
                },
                animation: controller,
              ),
            ],
          );
        },
        child: mainContent());
  }

  Widget mainContent() {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: 10),
      child: StreamBuilder(
          stream: bloc.feedList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                (snapshot.data as OrderRespone).data.length > 0) {
              stepPage = true;
              return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(children: [
                    Column(
                        children: (snapshot.data as OrderRespone)
                            .data
                            .asMap()
                            .map((key, value) => MapEntry(
                                key,
                                Column(
                                  children: [
                                    HistoryProductCard(
                                      pageVeiw: "success",
                                      type: widget.typeView,
                                      order: value,
                                      buttomAction: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          widget.typeView ==
                                                  OrderViewType.Purchase
                                              ? Text(
                                                  LocaleKeys.history_order_time
                                                          .tr() +
                                                      " ${value.createdAt.dateFormat()}",
                                                  style: FunctionHelper.fontTheme(
                                                      fontSize: SizeUtil
                                                              .titleSmallFontSize()
                                                          .sp,
                                                      color: Colors.black
                                                          .withOpacity(0.6)),
                                                )
                                              : SizedBox(),
                                          widget.typeView ==
                                                  OrderViewType.Purchase
                                              ? value.items[0].feedbackId!=null?buildButtonBayItem(
                                                  btnTxt: LocaleKeys
                                                      .me_title_again
                                                      .tr(),
                                                  item: value): buildButtonRate(item: value)
                                              : SizedBox()
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                )))
                            .values
                            .toList()),
                    if ((snapshot.data as OrderRespone).data.length !=
                        (snapshot.data as OrderRespone).total)
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Platform.isAndroid
                                ? SizedBox(
                                    width: 5.0.w,
                                    height: 5.0.w,
                                    child: CircularProgressIndicator())
                                : CupertinoActivityIndicator(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(LocaleKeys.dialog_message_loading.tr(),
                                style: FunctionHelper.fontTheme(
                                    color: Colors.grey,
                                    fontSize: SizeUtil.titleFontSize().sp))
                          ],
                        ),
                      ),
                  ]));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Platform.isAndroid
                    ? CircularProgressIndicator()
                    : CupertinoActivityIndicator(),
              );
            } else {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 15.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/boxorder.json',
                          height: 70.0.w, width: 70.0.w, repeat: false),
                      Text(
                        LocaleKeys.search_product_not_found.tr(),
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Future<Null> onRefresh() async {
    if (Platform.isAndroid) {
      await Future.delayed(Duration(seconds: 2));
    }

    page = 1;

    Usermanager().getUser().then((value) => bloc.loadOrder(context,
        orderType:
            widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
        statusId: "6",
        sort: "orders.updatedAt:desc",
        limit: limit,
        page: 1,
        token: value.token));

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          200) {
        if (stepPage) {
          stepPage = false;
          page++;
          _reloadData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Platform.isAndroid
        ? androidRefreshIndicator()
        : iosRefreshIndicator();
  }

  Widget buildButtonBayItem({String btnTxt, OrderData item}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.only(
            right: SizeUtil.iconSize().w,
            left: SizeUtil.iconSize().w,
            bottom: SizeUtil.paddingItem().h,
            top: SizeUtil.paddingItem().h)),
        backgroundColor: MaterialStateProperty.all(
          ThemeColor.colorSale(),
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () async {
        if (widget.typeView == OrderViewType.Purchase) {
      
          Usermanager().getUser().then((value) => bloc.getOrderById(context,
              orderType:
              widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
              id: item.id,
              token: value.token));

        } else {
          // AppRoute.TransferPayMentView(context: context,orderData: item);
        }
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }


  Widget buildButtonRate({ OrderData item}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.only(
            right: SizeUtil.iconSize().w,
            left: SizeUtil.iconSize().w,
            bottom: SizeUtil.paddingItem().h,
            top: SizeUtil.paddingItem().h)),
        backgroundColor: MaterialStateProperty.all(
          ThemeColor.colorSale(),
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () async {

        AppRoute.review(context, item);
      },
      child: Text(
        "${LocaleKeys
            .btn_review
            .tr()}",
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  _reloadData() {
    Usermanager().getUser().then((value) => bloc.loadOrder(context,
        orderType:
            widget.typeView == OrderViewType.Shop ? "myshop/orders" : "order",
        sort: "orders.updatedAt:desc",
        statusId: "6",
        limit: limit,
        page: page,
        token: value.token));
  }

  bool get wantKeepAlive => true;
}

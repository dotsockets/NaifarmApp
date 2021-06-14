import 'dart:io';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/CouponCard.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class CouponView extends StatefulWidget {
  final int shopId;
  CouponView({Key key, this.shopId}) : super(key: key);

  @override
  _CouponViewState createState() => _CouponViewState();
}

class _CouponViewState extends State<CouponView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _indicatorController = IndicatorController();
  CartBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogRetry(context,
            title: LocaleKeys.btn_error.tr(),
            message: event.message,
            callCancle: () {
              AppRoute.poppageCount(context: context, countpage: 2);
            },
            callBack: () => {});
      });
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is bool) {
          if (event) {
            onRefresh();
          }
        }
      });

      Usermanager().getUser().then((value) {
        bloc.getCouponlists(context: context, token: value.token);
      });
    }
  }

  Future<void> onRefresh() async {
    Usermanager().getUser().then((value) {
      bloc.getCouponlists(context: context, token: value.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 6.5.h,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: ThemeColor.primaryColor(),
              title: Text(
                LocaleKeys.coupon_coupon_title.tr(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FunctionHelper.fontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              actions: [
                Container(
                  padding: EdgeInsets.only(
                      right: SizeUtil.paddingCart().w,
                      left: SizeUtil.paddingItem().w),
                  child: IconButton(
                    onPressed: () async {
                      await AppRoute.couponAdd(
                              context: context, shopId: widget.shopId)
                          .then((value) => onRefresh());
                    },
                    icon: Icon(
                      Icons.add,
                      size: SizeUtil.mediumIconSize().w,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: Colors.grey.shade300,
            body: Platform.isAndroid
                ? androidRefreshIndicator()
                : iosRefreshIndicator()),
      ),
    );
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
                      bloc.onSuccess.hasValue
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
      child: SingleChildScrollView(
        child: StreamBuilder(
            stream: bloc.couponList.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var item = (snapshot.data as CouponResponse);
                return Column(
                  children: item.data.map((e) => coupons(e)).toList(),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget coupons(CouponData data) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: CouponCard(
          couponData: data,
          onTab: () async {
            var result = await AppRoute.couponAdd(
                context: context, couponEdit: data, shopId: widget.shopId);
            if (result != null) {
              onRefresh();
            }
          }),
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.red,
          iconWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/json/delete.json',
                  height: 4.0.h, width: 4.0.h, repeat: true),
              Text(
                LocaleKeys.cart_del.tr(),
                style: FunctionHelper.fontTheme(
                    color: Colors.white,
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          onTap: () {
            Usermanager().getUser().then((value) {
              bloc.deleteCoupon(context, token: value.token, couponId: data.id);
            });
          },
        )
      ],
    );
  }
}

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
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class AddressView extends StatefulWidget {
  @override
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onUpdate = false;
  CartBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogRetry(context,
            cancalMessage: LocaleKeys.btn_exit.tr(),
            callCancle: () {
              AppRoute.poppageCount(context: context, countpage:2);
            },
            title: LocaleKeys.btn_error.tr(),
            message: event.message,
            callBack: () {
             _getAddrList();
            });
      });

      bloc.onSuccess.stream.listen((event) {
        onUpdate = true;
      });
      _getAddrList();
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return WillPopScope(
      onWillPop: () async {
        checkCallBack();
        return true;
      },
      child: Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.grey.shade300,
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(7.0.h),
                  child: AppToobar(
                    title: LocaleKeys.setting_account_address_toobar.tr(),
                    headerType: Header_Type.barNormal,
                    icon: "",
                    isEnableSearch: false,
                    onClick: () => checkCallBack(),
                  ),
                ),
                body: StreamBuilder(
                    stream: bloc.addressList.stream,
                    builder: (context, snapshot) {
                      var item = (snapshot.data as AddressesListRespone);
                      if (snapshot.hasData && item.data != null) {
                        if (item.data.isNotEmpty) {
                          return SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  Column(
                                    children: item.data
                                        .asMap()
                                        .map((index, value) {
                                          return MapEntry(
                                              index,
                                              Column(
                                                children: [
                                                  buildCard(
                                                      item: value,
                                                      index: index),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  )
                                                ],
                                              ));
                                        })
                                        .values
                                        .toList(),
                                  ),
                                  SizedBox(
                                    height: 2.0.h,
                                  ),
                                  _buildBtnAddProduct(),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Expanded(
                                    child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 15.0.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Lottie.asset(
                                            'assets/json/boxorder.json',
                                            height: 70.0.w,
                                            width: 70.0.w,
                                            repeat: false),
                                        Text(
                                          LocaleKeys.search_product_not_found
                                              .tr(),
                                          style: FunctionHelper.fontTheme(
                                              fontSize:
                                                  SizeUtil.titleFontSize().sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 3.0.h),
                                        _buildBtnAddProduct(),
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          );
                        }
                      } else {
                        return SizedBox();
                      }
                    }))),
      ),
    );
  }

  Widget buildCard({AddressesData item, int index}) {
    return GestureDetector(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          padding: EdgeInsets.all(2.0.w),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 3.0.w,
                height: 3.0.w,
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.addressTitle,
                              textAlign: TextAlign.start,
                              style: FunctionHelper.fontTheme(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  height: 1.6,
                                  color: ThemeColor.primaryColor()),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 1.0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  item.addressType == "Primary"
                                      ? Text(LocaleKeys.address_default.tr(),
                                          style: FunctionHelper.fontTheme(
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  SizeUtil.titleFontSize().sp,
                                              color: ThemeColor.colorSale()))
                                      : SizedBox(),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey.shade500,
                                    size: SizeUtil.imgMedWidth().w,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        item.phone,
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.grey,
                            height: 1.5),
                      ),
                      Text(
                        "${item.addressLine1} ${item.city.name} ${item.state.name} ${item.zipCode} ",
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.grey,
                            height: 1.5),
                      ),
                      /*   Text(
                        item.zipCode,
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            height: 1.5),
                      ),*/
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            color: ThemeColor.secondaryColor(),
            iconWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/json/edit.json',
                    height: 5.0.h, width: 5.0.h, repeat: true),
                Text(
                  LocaleKeys.cart_edit.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            onTap: () async {
              var result = await AppRoute.addressEdit(context, item);
              if (result != null) {
                onUpdate = true;
                Usermanager().getUser().then(
                    (value) => bloc.addressesList(context, token: value.token));
              }
            },
          ),
          IconSlideAction(
            color: ThemeColor.colorSale(),
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
              onUpdate = true;
              Usermanager().getUser().then((value) => bloc.deleteAddress(
                  context,
                  id: item.id.toString(),
                  token: value.token));
            },
          )
        ],
      ),
      // Dismissible(
      //   child: ,
      //   background: Container(
      //     padding: EdgeInsets.only(right: 30),
      //     alignment: Alignment.centerRight,
      //     color: ThemeColor.colorSale(),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Lottie.asset('assets/json/delete.json',
      //             height: 30, width: 30, repeat: true),
      //         Text(
      //           LocaleKeys.cart_del.tr(),
      //           style: FunctionHelper.fontTheme(
      //               color: Colors.white,
      //               fontSize: SizeUtil.titleFontSize().sp,
      //               fontWeight: FontWeight.bold),
      //         )
      //       ],
      //     ),
      //   ),
      //   key: Key("${item.id}"),
      //   onDismissed: (direction) {
      //     onUpdate = true;
      //     Usermanager().getUser().then((value) => bloc.DeleteAddress(id: item.id.toString(),token: value.token));
      //   },
      // ),

      onTap: () async {
        var result = await AppRoute.addressEdit(context, item);
        if (result != null) {
          onUpdate = true;
          Usermanager()
              .getUser()
              .then((value) => bloc.addressesList(context, token: value.token));
        }
      },
    );
  }

  Widget _buildBtnAddProduct() {
    return Center(
      child: Container(
        width: 50.0.w,
        height: 5.0.h,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              ThemeColor.secondaryColor(),
            ),
            overlayColor: MaterialStateProperty.all(
              Colors.white.withOpacity(0.3),
            ),
          ),
          onPressed: () async {
            final result = await AppRoute.settingAddAddress(context);
            if (result) {
              onUpdate = true;
              Usermanager().getUser().then(
                  (value) => bloc.addressesList(context, token: value.token));
            }
          },
          child: Text(
            LocaleKeys.btn_add_address.tr(),
            style: FunctionHelper.fontTheme(
                color: Colors.white,
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  void checkCallBack() {
    if (bloc.addressList.value.data != null) {
      List<AddressesData> returnData = <AddressesData>[];

      for (var item in bloc.addressList.value.data) {
        if (item.addressType == "Primary") {
          returnData.add(AddressesData(
              id: item.id,
              addressLine1: item.addressLine1,
              addressLine2: item.addressLine2,
              addressTitle: item.addressTitle,
              addressType: "Primary",
              cityId: 1,
              phone: item.phone,
              select: true,
              stateId: item.stateId,
              zipCode: item.zipCode));
          break;
        }
      }
      Navigator.pop(context,
          AddressesListRespone(data: returnData, total: returnData.length));
    } else {
      Navigator.pop(context, AddressesListRespone());
    }
  }

  _getAddrList(){

    Usermanager()
        .getUser()
        .then((value) => bloc.addressesList(context, token: value.token));
  }
}

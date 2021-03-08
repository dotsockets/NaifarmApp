import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/AddressBloc.dart';
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
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event.message);
      });

      bloc.onSuccess.stream.listen((event) {
        onUpdate = true;
        //  cartReq = event;
      });

      Usermanager()
          .getUser()
          .then((value) => bloc.AddressesList(context,token: value.token));

    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return WillPopScope(
      onWillPop: ()async{
        check_call_back();
        return true;
      },
      child: Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.grey.shade300,
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(6.5.h),
                  child: AppToobar(
                    title: LocaleKeys.setting_account_address_toobar.tr(),
                    header_type: Header_Type.barNormal,
                    icon: "",
                    isEnable_Search: false,
                    onClick: ()=>check_call_back(),
                  ),
                ),
                body: Container(

                  child: StreamBuilder(
                      stream: bloc.AddressList.stream,
                      builder: (context, snapshot) {
                        var item = (snapshot.data as AddressesListRespone);
                        if (snapshot.hasData && item.data!=null) {
                          if(item.data.isNotEmpty){
                            return SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: [
                                    Column(
                                      children: item.data
                                          .asMap()
                                          .map((index, value) {
                                        return MapEntry(index,
                                            Column(
                                              children: [
                                                _BuildCard(item: value, index: index),
                                                SizedBox(height: 1.0.h,)
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
                          }else{
                            return Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Expanded(child: Center(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 15.0.h),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset('assets/json/boxorder.json',
                                              height: 70.0.w, width: 70.0.w, repeat: false),
                                          Text(
                                            LocaleKeys.search_product_not_found.tr(),
                                            style: FunctionHelper.FontTheme(
                                                fontSize: SizeUtil.titleFontSize().sp,
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
                      }),
                ))),
      ),
    );
  }

  Widget _BuildCard({AddressesData item, int index}) {
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
             SizedBox(width: 3.0.w,height: 3.0.w,),
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
                              style: FunctionHelper.FontTheme(
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
                                  item.addressType=="Primary"
                                      ? Text(LocaleKeys.address_default.tr(),
                                      style: FunctionHelper.FontTheme(
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeUtil.titleFontSize().sp,
                                          color: ThemeColor.ColorSale()))
                                      : SizedBox(),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey.shade500,
                                    size: 5.0.w,
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
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.grey,
                            height: 1.5),
                      ),
                      Text(
                        item.addressLine1,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            color: Colors.grey,
                            height: 1.5),
                      ),
                   /*   Text(
                        item.zipCode,
                        style: FunctionHelper.FontTheme(
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
                    height: 5.0.h,
                    width: 5.0.h,
                    repeat: true),
                Text(
                  LocaleKeys.cart_edit.tr(),
                  style: FunctionHelper.FontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            onTap: () async {
              var result = await AppRoute.AddressEdit(context, item);
              if (result != null) {
                onUpdate = true;
                Usermanager()
                    .getUser()
                    .then((value) => bloc.AddressesList(context,token: value.token));

              }
            },
          ),
          IconSlideAction(
            color: ThemeColor.ColorSale(),
            iconWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/json/delete.json',
                    height: 4.0.h,
                    width: 4.0.h,
                    repeat: true),
                Text(
                  LocaleKeys.cart_del.tr(),
                  style: FunctionHelper.FontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            onTap: () {
              onUpdate = true;
              Usermanager().getUser().then((value) => bloc.DeleteAddress(context,id: item.id.toString(),token: value.token));
            },
          )

        ],
      ),
      // Dismissible(
      //   child: ,
      //   background: Container(
      //     padding: EdgeInsets.only(right: 30),
      //     alignment: Alignment.centerRight,
      //     color: ThemeColor.ColorSale(),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Lottie.asset('assets/json/delete.json',
      //             height: 30, width: 30, repeat: true),
      //         Text(
      //           LocaleKeys.cart_del.tr(),
      //           style: FunctionHelper.FontTheme(
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

      onTap: ()async{
        var result = await AppRoute.AddressEdit(context, item);
        if (result != null) {
          onUpdate = true;
          Usermanager()
              .getUser()
              .then((value) => bloc.AddressesList(context,token: value.token));

        }
      },
    );
  }

  Widget _buildBtnAddProduct() {
    return Center(
      child: Container(
        width: 50.0.w,
        height: 6.0.h,
        child: FlatButton(
          color: ThemeColor.secondaryColor(),
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () async {
            final result = await AppRoute.SettingAddAddress(context);
            if (result) {
              onUpdate = true;
              Usermanager()
                  .getUser()
                  .then((value) => bloc.AddressesList(context,token: value.token));
            }
          },
          child: Text(
            LocaleKeys.btn_add_address.tr(),
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }


  void check_call_back(){
    if(bloc.AddressList.value.data!=null){
      List<AddressesData>  returnData = List<AddressesData>();

      for(var item in bloc.AddressList.value.data){
        if(item.addressType=="Primary"){
          returnData.add(AddressesData(id: item.id,addressLine1: item.addressLine1,addressLine2: item.addressLine2,addressTitle: item.addressTitle,addressType: "Primary",
              cityId: 1,phone: item.phone,select: true,stateId: item.stateId,zipCode: item.zipCode));
          break;
        }
      }
      Navigator.pop(context, AddressesListRespone(data: returnData,total: returnData.length));
    }else{
      Navigator.pop(context, AddressesListRespone());
    }

  }
}

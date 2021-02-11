import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/models/AddressModel.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class CartAaddressView extends StatefulWidget {
  final AddressesData install_select;

  const CartAaddressView({Key key, this.install_select}) : super(key: key);
  @override
  _CartAaddressViewState createState() => _CartAaddressViewState();
}

class _CartAaddressViewState extends State<CartAaddressView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int select = 0;
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
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event.error.message);
      });

      bloc.onSuccess.stream.listen((event) {
        onUpdate = true;
        //  cartReq = event;
      });

      Usermanager()
          .getUser()
          .then((value) => bloc.AddressesList(token: value.token));

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
                    title: LocaleKeys.setting_account_title_address.tr(),
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

                          return SingleChildScrollView(
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
                          );
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
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(2.0.w),
                  child: item.select
                      ? SvgPicture.asset(
                    'assets/images/svg/checkmark.svg',
                    width: 6.0.w,
                    height: 6.0.w,
                    color: ThemeColor.primaryColor(),
                  )
                      : SvgPicture.asset(
                    'assets/images/svg/uncheckmark.svg',
                    width: 6.0.w,
                    height: 6.0.w,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
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
                                  item.select
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
                            height: 1.5),
                      ),
                      Text(
                        item.addressLine1,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            height: 1.5),
                      ),
                      Text(
                        item.zipCode,
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            height: 1.5),
                      ),
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
                  LocaleKeys.cart_del.tr(),
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
                    .then((value) => bloc.AddressesList(token: value.token));

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
              Usermanager().getUser().then((value) => bloc.DeleteAddress(id: item.id.toString(),token: value.token));
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
      onLongPress: () async {
        var result = await AppRoute.AddressEdit(context, item);
        if (result != null) {
          onUpdate = true;
          Usermanager()
              .getUser()
              .then((value) => bloc.AddressesList(token: value.token));
        }
      },
      onTap: (){

        for(var i=0;i<bloc.AddressList.value.data.length;i++){
          if(bloc.AddressList.value.data[i].id == item.id){
            bloc.AddressList.value.data[i].select = true;
            bloc.AddressList.value.data[i].addressType = "Primary";
          }else{
            bloc.AddressList.value.data[i].select = false;
            bloc.AddressList.value.data[i].addressType = "";
          }
        }
        bloc.AddressList.add(bloc.AddressList.value);

        //print("ewdfcesr ${widget.install_select!=null}")

         if(widget.install_select==null || widget.install_select.id!=item.id){
          Usermanager().getUser().then((value) =>     bloc.UpdateAddress(data: AddressCreaterequest(countryId: 1,id: item.id,cityId: item.cityId,phone: item.phone,addressLine1: item.addressLine1,
              addressLine2: "",addressTitle: item.addressTitle,stateId: item.stateId,zipCode: item.zipCode,addressType: "Primary"),token: value.token));
        }

        List<AddressesData>  returnData = List<AddressesData>();
        returnData.add(AddressesData(id: item.id,addressLine1: item.addressLine1,addressLine2: item.addressLine2,addressTitle: item.addressTitle,addressType: "Primary",
        cityId: 1,phone: item.phone,select: true,stateId: item.stateId,zipCode: item.zipCode));
        Navigator.pop(context, AddressesListRespone(data: returnData,total: returnData.length));
      },
    );
  }

  Widget _buildBtnAddProduct() {
    return Center(
      child: Container(
        width: 50.0.w,
        height: 5.0.h,
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
                  .then((value) => bloc.AddressesList(token: value.token));
            }
          },
          child: Text(
            LocaleKeys.add_address_btn.tr(),
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

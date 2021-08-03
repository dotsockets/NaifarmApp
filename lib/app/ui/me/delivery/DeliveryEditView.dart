import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/ShippingBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CarriersRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class DeliveryEditView extends StatelessWidget {

  final ShppingMyShopRespone shppingMyShopRespone;
  final CarriersData carriersData;

   DeliveryEditView(
      {Key key, this.shppingMyShopRespone, this.carriersData})
      : super(key: key);

  TextEditingController rateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String onError = "";
  bool isHave = false;
  Rates rates;
  ShippingBloc bloc;
  final onChang = BehaviorSubject<Object>();

  init(BuildContext context) {
    if (bloc == null) {
      _initialValue();
      bloc = ShippingBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, event);
      });
      bloc.onError.stream.listen((event) {
       // FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event);
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
      // Usermanager().getUser().then((value) => bloc.loadShppingPage(token: value.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
        preferredSize: Size.fromHeight(7.5.h),
            child: AppToobar(
              title: LocaleKeys.shipping_edit.tr(),
              icon: "",
              headerType: Header_Type.barNormal,
              isEnableSearch: false,
              onClick: () {
                Navigator.pop(context, false);
              },
            ),
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(2.0.w),
                  child: Text("${carriersData.name}",
                      style: FunctionHelper.fontTheme(
                          fontSize: SizeUtil.titleFontSize().sp,
                          fontWeight: FontWeight.w600)),
                ),
                StreamBuilder(stream: onChang.stream,builder: (context,snapshot){
                  return Container(
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: BuildEditText(
                        head: LocaleKeys.my_product_delivery_price.tr(),
                        hint: LocaleKeys.set_default.tr() +
                            LocaleKeys.my_product_delivery_price.tr(),
                        maxLength: 10,
                        controller: rateController,
                        onError: onError,
                        inputType: TextInputType.number,
                        isPassword: false,
                        borderOpacity: 0.2,
                        onChanged: (String char) {

                          RegExp _numeric = RegExp(r'^-?[0-9]+$');
                          if (!_numeric.hasMatch(rateController.text))
                            rateController.text = "";

                          onChang.add(true);
                        }),
                  );
                }),
                SizedBox(
                  height: 1.0.w,
                ),
                isHave
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.only(right: 1.0.w, left: 1.0.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      right: 3.0.w,
                                      left: 3.0.w,
                                      top: 4.0.w,
                                      bottom: 4.0.w),
                                  child: StreamBuilder(stream: onChang.stream,builder: (context,snapshot){
                                    return buildItem(context);

                                  }),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      right: 3.0.w,
                                      left: 3.0.w,
                                      top: 4.0.w,
                                      bottom: 4.0.w),
                                  child: StreamBuilder(builder: (context,snapshot){
                                    return TextButton(
                                      style: ButtonStyle(

                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(40.0),
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                          Size(50.0.w, 5.0.h),
                                        ),
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                          formCheck()
                                              ? ThemeColor.colorSale()
                                              : Colors.grey.shade400,
                                        ),
                                        overlayColor: MaterialStateProperty.all(
                                          Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (formCheck()) {
                                          Usermanager().getUser().then((value) =>
                                              bloc.deleteShoppingMyShop(context,
                                                  ratesId: rates.id,
                                                  token: value.token));
                                        }
                                      },
                                      child: Text(
                                        LocaleKeys.shipping_cancel.tr(),
                                        style: FunctionHelper.fontTheme(
                                            color: Colors.white,
                                            fontSize: SizeUtil.titleFontSize().sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 3.0.w,
                ),
                isHave == false ? Center(child: StreamBuilder(stream: onChang.stream,builder: (context,snapshot){

                  return buildItem(context);

                })) : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context) => TextButton(
        style: ButtonStyle(

          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            Size(50.0.w, 5.0.h),
          ),
          backgroundColor: MaterialStateProperty.all(
            formCheck() ? ThemeColor.secondaryColor() : Colors.grey.shade400,
          ),
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.3),
          ),
        ),
        onPressed: () {
          if (formCheck()) {
            if (isHave) {
              Usermanager().getUser().then((value) => bloc.editShoppingMyShop(
                  context,
                  rateID: rates.id,
                  shopRequest: ShppingMyShopRequest(
                      shippingZoneId:
                          shppingMyShopRespone.data[0].shopId,
                      rate: int.parse(rateController.text),
                      carrierId: carriersData.id,
                      basedOn: "price",
                      minimum: 0,
                      maximum: 0,
                      name: carriersData.name),
                  token: value.token));
            } else {
              Usermanager().getUser().then((value) => bloc.addShoppingMyShop(
                  context,
                  shopRequest: ShppingMyShopRequest(
                      shippingZoneId:
                          shppingMyShopRespone.data[0].shopId,
                      rate: int.parse(rateController.text),
                      carrierId: carriersData.id,
                      basedOn: "price",
                      minimum: 0,
                      maximum: 0,
                      name: carriersData.name),
                  token: value.token));
            }
          }
        },
        child: Text(
          LocaleKeys.btn_continue.tr(),
          style: FunctionHelper.fontTheme(
              color: Colors.white,
              fontSize: SizeUtil.titleFontSize().sp,
              fontWeight: FontWeight.w500),
        ),
      );

  bool formCheck() {
    if (rateController.text.trim().isEmpty) {
      return false;
    } else {
      return true;
    }
  }
  _initialValue(){
    for (var item in shppingMyShopRespone.data[0].rates) {
      if (carriersData.id == item.carrierId) {
        rateController.text = item.rate.toString()!="null"?item.rate.toString():"0";
        isHave = true;
        rates = item;
        break;
      }
    }
  }
}

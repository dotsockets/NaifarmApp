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
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sizer/sizer.dart';

class DeliveryEditView extends StatefulWidget {
  final ShppingMyShopRespone shppingMyShopRespone;
  final CarriersData carriersData;

  const DeliveryEditView(
      {Key key, this.shppingMyShopRespone, this.carriersData})
      : super(key: key);

  @override
  _DeliveryEditViewState createState() => _DeliveryEditViewState();
}

class _DeliveryEditViewState extends State<DeliveryEditView> {
  TextEditingController RateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String onError = "";
  bool IsHave = false;
  Rates rates;
  ShippingBloc bloc;

  init(){
    if(bloc==null){
      for(var item in widget.shppingMyShopRespone.data[0].rates){
        if(widget.carriersData.id == item.carrierId){
          RateController.text = item.rate.toString();
          IsHave = true;
          rates = item;
          break;
        }
      }
      bloc = ShippingBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, event);
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
     // Usermanager().getUser().then((value) => bloc.loadShppingPage(token: value.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppToobar(
            title: "แก้ไขการส่งสินค้า",
            icon: "",
            header_type: Header_Type.barNormal,
            isEnable_Search: false,
            onClick: (){
              Navigator.pop(context, false);
            },
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(2.0.w),
                  child: Text("${widget.carriersData.name}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  color: Colors.white,
                  child: BuildEditText(
                      head: "ค่าขนส่ง",
                      hint: "ระบุค่าขนส่ง",
                      maxLength: 10,
                      controller: RateController,
                      onError: onError,
                      inputType: TextInputType.number,
                      IsPassword: false,
                      BorderOpacity: 0.2,
                      onChanged: (String char) {
                        RegExp _numeric = RegExp(r'^-?[0-9]+$');
                        if(!_numeric.hasMatch(RateController.text))
                          RateController.text = "";

                        setState(() {});

                      }),
                ),
                SizedBox(height: 1.0.w,),
                IsHave?Center(
                  child: Container(
                    padding: EdgeInsets.only(right: 1.0.w,left: 1.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right:3.0.w,left: 3.0.w,top:4.0.w,bottom: 4.0.w),
                            child: BuildItem(),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right:3.0.w,left: 3.0.w,top:4.0.w,bottom: 4.0.w),
                            child: FlatButton(
                              minWidth: 50.0.w,
                              height: 6.0.h,
                              color: FormCheck()?ThemeColor.ColorSale():Colors.grey.shade400,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.grey.shade500,
                              onPressed: () {
                                if(FormCheck()){
                                  Usermanager().getUser().then((value) => bloc.DELETEShoppingMyShop(ratesId: rates.id,token: value.token));
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Text("ยกเลิกการเชื่อมการขนส่ง",
                                style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ):SizedBox(),
                SizedBox(height: 20,),
                IsHave==false?Center(
                  child: BuildItem()):SizedBox()

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BuildItem()=> FlatButton(
    minWidth: 50.0.w,
    height: 6.0.h,
    color: FormCheck()?ThemeColor.secondaryColor():Colors.grey.shade400,
    textColor: Colors.white,
    disabledColor: Colors.grey,
    disabledTextColor: Colors.black,
    padding: EdgeInsets.all(8.0),
    splashColor: Colors.grey.shade500,
    onPressed: () {
      if(FormCheck()){
          if(IsHave){
            Usermanager().getUser().then((value) => bloc.EditShoppingMyShop(rateID: rates.id,shopRequest: ShppingMyShopRequest(shippingZoneId: widget.shppingMyShopRespone.data[0].shopId,
                rate: int.parse(RateController.text),carrierId: widget.carriersData.id,basedOn: "price",minimum: 0,maximum: 0,name: widget.carriersData.name),token: value.token));
          }else{
            Usermanager().getUser().then((value) => bloc.AddShoppingMyShop(shopRequest: ShppingMyShopRequest(shippingZoneId: widget.shppingMyShopRespone.data[0].shopId,
            rate: int.parse(RateController.text),carrierId: widget.carriersData.id,basedOn: "price",minimum: 0,maximum: 0,name: widget.carriersData.name),token: value.token));
          }
      }
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
    ),
    child: Text(LocaleKeys.continue_btn.tr(),
      style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
    ),
  );

  bool FormCheck(){
    if(RateController.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }
}

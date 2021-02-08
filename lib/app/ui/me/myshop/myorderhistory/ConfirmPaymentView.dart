import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class ConfirmPaymentView extends StatelessWidget {

  final OrderData orderData;


   ConfirmPaymentView({Key key, this.orderData}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  OrdersBloc bloc;

  init(BuildContext context) {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
    bloc.onSuccess.stream.listen((event) {
      Navigator.pop(context,true);
    });
    }
    // Usermanager().getUser().then((value) => context.read<OrderBloc>().loadOrder(statusId: 1, limit: 20, page: 1, token: value.token));
  }
  @override
  Widget build(BuildContext context) {
    init(context);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: AppToobar(
            title: "Confirm payment of order ",
            header_type: Header_Type.barcartShop,
            isEnable_Search: false,
            icon: '',
            onClick: (){
              Navigator.pop(context,false);
            },
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(child: Column(
                  children: <Widget>[
                    ItemInfo(PricecolorText: ThemeColor.ColorSale(),leading:"All buyer payment ",trailing: "฿${NumberFormat("#,##0.00", "en_US").format(orderData.grandTotal)}"),
                    SizedBox(height: 1.0.h),
                    ItemInfo(PricecolorText: Colors.grey.shade400,leading: "Total product cost",trailing: "฿${NumberFormat("#,##0.00", "en_US").format(orderData.total)}"),
                    ItemInfo(PricecolorText: Colors.grey.shade400,leading: "Shipping cost",trailing: "฿${NumberFormat("#,##0.00", "en_US").format(orderData.shipping)}"),
                    ItemInfo(PricecolorText: Colors.grey.shade400,leading: "Discount code",trailing: "฿${NumberFormat("#,##0.00", "en_US").format(orderData.discount)}"),
                    SizedBox(height: 1.0.h),
                    ItemInfo(PricecolorText: Colors.grey.shade400,leading: "Payment method",trailing: "${orderData.paymentMethod.name}"),
                  ],
                )),
                _ButtonActive(context: context,orderData: orderData)
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget ItemInfo({Color PricecolorText,String leading="",String trailing=""}){
    return  Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      padding: EdgeInsets.all(1.0.w),
      child: ListTile(leading:  Text(
        leading,
        style: FunctionHelper.FontTheme(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: SizeUtil.titleFontSize().sp),
      ),trailing: Text(
        trailing,
        style: FunctionHelper.FontTheme(
            color: PricecolorText,
            fontWeight: FontWeight.bold,
            fontSize: SizeUtil.titleFontSize().sp),
      )),
    );
  }

  Widget _ButtonActive({BuildContext context,OrderData orderData}){

    return Center(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(2.0.w),
        child: Center(
          child: FlatButton(
            minWidth: 50.0.w,
            height: 5.0.h,
            color:  ThemeColor.ColorSale() ,
            textColor: Colors.white,
            splashColor: Colors.white.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            onPressed: () {
              FunctionHelper.ConfirmDialog(context,message: "คุณต้องการยืนยันการชำระเงินคำสั่งซื้อสินค้านี้ ?",onCancel: (){
                Navigator.of(context).pop();
              },onClick: (){
                Navigator.of(context).pop();
                Usermanager().getUser().then((value) =>
                    bloc.MarkPaid(token: value.token,OrderId: orderData.id));
              });


            },
            child: Text(
              "Confirm ",
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );


  }

}

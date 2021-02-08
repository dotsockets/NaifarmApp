import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class ShippingOrderView extends StatelessWidget {
  final OrderData orderData;

   ShippingOrderView({Key key, this.orderData}) : super(key: key);

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
            title: "Shipping ",
            header_type: Header_Type.barcartShop,
            isEnable_Search: false,
            icon: '',
            onClick: (){
              Navigator.pop(context,false);
            },
          ),
          body: Container(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ItemInfo(icon: FontAwesome.inbox,title: "Drop Off",subtitle: "คุณสามารถทำการ Drop Off พัสดุของคุณได้ที่ J&T Express สาขาใกล้บ้านคุณ",
                onclick: (){
                  FunctionHelper.ConfirmDialog(context,message: "สำคัญ! คุณสามารถทำการ Drop Off พัสดุของคุณได้ที่ สาขาใกล้บ้านคุณ",onCancel: (){
                    Navigator.of(context).pop();
                  },onClick: (){
                    Navigator.of(context).pop();
                   AppRoute.DeliveryDropoff(context: context);
                  });

                }),
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  child: Text(
                    "เวลาทำการขึ้นอยู่กับแต่ละสาขา",
                    style: FunctionHelper.FontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleFontSize().sp),
                  ),
                ),
                ItemInfo(icon: FontAwesome.car,title: "นัดรับสินค้า",subtitle: "เจ้าหน้าที่ J&T Express จะเข้ารับพัสดุที่ที่อยู่ในการนัดรับสินค้าของคุณ"),
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  child: Text(
                    "ร้านค้าสามารถจองเวลาการเข้ารับสินค้าได้ วันจันทร์-อาทิตย์ ไม่เว้นวันหยุดราชการ ตั้งแต่เวลา 10:00 น. - 18:00 น.",
                    style: FunctionHelper.FontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleFontSize().sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget ItemInfo({IconData icon,String title,String subtitle="",Function() onclick}){
    return  Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      padding: EdgeInsets.all(1.0.w),
      child: ListTile(leading:  Container(
        padding: EdgeInsets.all(3.0.w),
        decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Icon(icon,size: 6.0.w,),
      ),title: Text(
        title,
        style: FunctionHelper.FontTheme(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: SizeUtil.titleFontSize().sp),
      ),subtitle: Text(
        subtitle,
        style: FunctionHelper.FontTheme(
            color: Colors.grey.shade600,
            fontSize: SizeUtil.titleFontSize().sp),
      ),onTap: (){
        if(onclick!=null){
          onclick();
        }
      }),
    );
  }

}



import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class OrderView extends StatefulWidget {
  final OrderData orderData;
  final String orderType;
  OrderView({Key key, this.orderData, this.orderType}) : super(key: key);
  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {

  OrdersBloc bloc;

  init() {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      if(widget.orderData.orderStatusName!=null){
        bloc.onSuccess.add(widget.orderData);
      }

    }
    Usermanager().getUser().then((value) => bloc.GetOrderById(orderType: widget.orderType,id: widget.orderData.id, token: value.token));
    // Usermanager().getUser().then((value) => context.read<OrderBloc>().loadOrder(statusId: 1, limit: 20, page: 1, token: value.token));
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppToobar(
            title: LocaleKeys.order_detail_title.tr(),
            header_type: Header_Type.barcartShop,
            icon: '',
          ),
          body: StreamBuilder(
            stream: bloc.feedList,
            builder: (BuildContext context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                var item = (snapshot.data as OrderData);
                if(snapshot.data!=null) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _HeaderStatus(context: context,orderData: item),
                                _labelText(title: LocaleKeys.order_detail_ship_addr.tr()),
                                _addtess_recive(context: context,orderData: item),
                                _labelText(title: LocaleKeys.order_detail_ship_data.tr()),
                                item.shippingRate!=null?_Shipping_information(context: context,orderData: item):SizedBox(),
                                item.shippingRate!=null?SizedBox(height: 15,):SizedBox(),
                                _Order_number_information(context: context,orderData: item,sumTotal: SumTotal(item.items),rate_delivery: item.shipping),
                                _labelText(title: LocaleKeys.order_detail_payment.tr()),
                                _payment_info(context: context,orderData: item),
                                SizedBox(height: 15,),
                                _Timeline_order(context: context,orderData: item)
                              ],
                            ),
                          ),
                        ),
                        _ButtonActive(context: context,orderData: item),
                      ],
                    ),
                  );
                }else{
                  return Container(color: Colors.white,child: SizedBox());
                }
              }else{
                return Container(color: Colors.white,child: Center(
                  child: Platform.isAndroid
                      ? SizedBox(width: 5.0.w,height: 5.0.w,child: CircularProgressIndicator())
                      : CupertinoActivityIndicator(),
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _HeaderStatusText({OrderData orderData}){
      return Container(
        width: 70.0.w,
        height: 6.0.h,
        margin: EdgeInsets.only(top: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: EdgeInsets.only(right: 13,left: 10,top: 5,bottom: 5),
            color: ThemeColor.primaryColor(),
            child: Center(child: Text(orderData.orderStatusName,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold,color: Colors.white),)),
          ),
        ),
      );
  }

  Widget _HeaderStatus({BuildContext context,OrderData orderData}){
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft: Radius.circular(40)),
              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text("Order ${orderData.orderNumber}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold),),
                SizedBox(height: 3),
                Text("กรุณาชำระเงินภายใน ${DateFormat('dd-MM-yyyy').format(DateTime.parse(orderData.requirePaymentAt!=null?orderData.requirePaymentAt:DateTime.now().toString()))} มิฉะนั้นระบบจะยกเลิกคำสั่งซื้อโดยอัตโนมัติ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.5)),)
              ]
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _HeaderStatusText(orderData: orderData),
        )
      ],
    );
  }
  
  Widget _labelText({String title}){
    return Container(
      padding: EdgeInsets.only(left: 15,top: 15,bottom: 15),
      child: Text(title,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold),),
    );
  }

  Widget _addtess_recive({BuildContext context,OrderData orderData}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(orderData.shippingAddress,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
             ],
        ),
    );
  }


  Widget _Shipping_information({BuildContext context,OrderData orderData}){

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(orderData.shippingRate.carrier!=null?orderData.shippingRate.carrier.name:'',style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: ThemeColor.primaryColor(),fontWeight: FontWeight.bold,height: 1.5),),
          SizedBox(height: 1.0.w),
          Text(orderData.shippingRate.name+" ${orderData.shippingRate.deliveryTakes}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
         // SizedBox(height: 6),
        //  Text("${orderData.shippingRate.deliveryTakes} ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
        ],
      ),
    );
  }

  Widget _Order_number_information({BuildContext context,OrderData orderData,int sumTotal,int rate_delivery}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.order_detail_order_num.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                Text(orderData.orderNumber,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color:ThemeColor.ColorSale(),fontWeight: FontWeight.bold,height: 1.5),),
              ],
            ),
            SizedBox(height: 13,),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: CachedNetworkImage(
                          width: 30,
                          height: 30,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child:
                            Lottie.asset('assets/json/loading.json', height: 30),
                          ),
                          fit: BoxFit.cover,
                          imageUrl: "${Env.value.baseUrl}/storage/images/${orderData.shop.image.isNotEmpty ? orderData.shop.image[0].path : ''}",
                          errorWidget: (context, url, error) => Container(
                              height: 30,
                              child: Icon(
                                Icons.error,
                                size: 30,
                              )),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text(orderData.shop.name,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),)
                    ],
                  ),
                  Row(
                    children: [
                      Container(margin: EdgeInsets.only(bottom: 0.8.h),child: Text(LocaleKeys.order_detail_go_shop.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),)),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,size: 4.0.w,)
                    ],
                  ),
                ],
              ),
              onTap: (){
                var item = orderData.shop;
                AppRoute.ShopMain(context: context,myShopRespone: MyShopRespone(id: item.id,name: item.name,image: item.image,updatedAt: item.updatedAt));
              },
            ),
            SizedBox(height: 13,),
            Column(
              children: orderData.items.asMap().map((key, value) => MapEntry(key,Column(
                children: [
                  ItemProduct(orderItems: orderData.items[key]),
                  SizedBox(height: 1.0.h,)
                ],
              ))).values.toList(),
            ),
            SizedBox(height: 13,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.order_detail_subtotal.tr()+" :",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                SizedBox(width: 10,),
                Text("฿${NumberFormat("#,##0.00", "en_US").format(sumTotal)}", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, color: Colors.black))
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.order_detail_ship_price.tr()+" :",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                SizedBox(width: 10,),
                Text("฿${NumberFormat("#,##0.00", "en_US").format(rate_delivery!=null?rate_delivery:0)}", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, color: Colors.black))
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.order_detail_total.tr()+" :",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                SizedBox(width: 10,),
                Text("฿${NumberFormat("#,##0.00", "en_US").format(sumTotal+(rate_delivery!=null?rate_delivery:0))}", style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, color: ThemeColor.ColorSale()))
              ],
            ),

          ],
        ),
    );
  }


  Widget ItemProduct({OrderItems orderItems}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.1))),
          child: CachedNetworkImage(
            width: 22.0.w,
            height: 22.0.w,
            placeholder: (context, url) => Container(
              width: 22.0.w,
              height: 22.0.w,
              color: Colors.white,
              child: Lottie.asset('assets/json/loading.json', height: 30),
            ),
            fit: BoxFit.cover,
            imageUrl: "${Env.value.baseUrl}/storage/images/${orderItems.inventory.product.image.isNotEmpty?orderItems.inventory.product.image[0].path : ''}",
            errorWidget: (context, url, error) => Container(
                width: 22.0.w,
                height: 22.0.w,
                child: Icon(
                  Icons.error,
                  size: 30,
                )),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${orderItems.inventory.title}",
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("x ${orderItems.quantity}",
                      style: FunctionHelper.FontTheme(
                          fontSize: SizeUtil.titleFontSize().sp, color: Colors.black, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      // Text("฿${orderItems.inventory.offerPrice}",
                      //     style: FunctionHelper.FontTheme(
                      //         fontSize: SizeUtil.titleFontSize().sp,
                      //         decoration: TextDecoration.lineThrough,color: Colors.black.withOpacity(0.5))),
                      // SizedBox(width: 8),
                      Text("฿${NumberFormat("#,##0.00", "en_US").format(orderItems.inventory.salePrice*orderItems.quantity)}",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp, color: Colors.black))
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _payment_info({BuildContext context,OrderData orderData}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          // CachedNetworkImage(
          //   height: 30,
          //   placeholder: (context, url) => Container(
          //     color: Colors.white,
          //     child:
          //     Lottie.asset('assets/json/loading.json', height: 30),
          //   ),
          //   fit: BoxFit.cover,
          //   imageUrl: "https://img.utdstc.com/icons/scb-easy-android.png:225",
          //   errorWidget: (context, url, error) => Container(
          //       height: 30,
          //       child: Icon(
          //         Icons.error,
          //         size: 30,
          //       )),
          // ),
          Icon(Icons.money),
          SizedBox(width: 10,),
          Text(orderData.paymentMethod.name, style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp, color: Colors.black,fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _Timeline_order({BuildContext context,OrderData orderData}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.order_detail_order_num.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
              Text(orderData.orderNumber,style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,color:ThemeColor.ColorSale(),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.order_detail_buy_time.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderData.createdAt))}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.order_detail_pay_time.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("${orderData.paymentAt!=null?DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderData.paymentAt)):''}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.order_detail_ship_time.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("${orderData.shippingDate!=null?DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderData.shippingDate)):''}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.order_detail_complete_time.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("${orderData.deliveryDate!=null?DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderData.deliveryDate)):''}",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
        ],
      ),
    );
  }

  Widget _ButtonActive({BuildContext context,OrderData orderData}){
    
      return Center(
        child: Container(
          padding: EdgeInsets.all(1.5.w),
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


              },
              child: Text(
                "Cancel order",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      );


  }

  int SumTotal(List<OrderItems> items) {
    var sum = 0;
    for (var item in items) {
      sum += item.inventory.salePrice;
    }
    return sum;
  }

}

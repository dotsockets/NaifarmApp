
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class OrderSuccessView extends StatefulWidget {

  final String payment_total;

  const OrderSuccessView({Key key, this.payment_total}) : super(key: key);
  @override
  _OrderSuccessViewState createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

 init(){

   Usermanager().getUser().then((value){
     Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
   });

 }
  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            key: _scaffoldKey,
            appBar: AppToobar(
              title: "The order is complete",
              header_type: Header_Type.barNormal,
              icon: "",onClick: ()=> AppRoute.PoppageCount(context: context,countpage: 3),
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  color: ThemeColor.primaryColor(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10,),
                      Text("Order details",
                          style: FunctionHelper.FontTheme(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/images/svg/checkmark.svg',color: Colors.white,width: 25,height: 25,),
                          SizedBox(width: 10,),
                          Text("The order is complete.",
                              style: FunctionHelper.FontTheme(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("Payment amount ฿${NumberFormat("#,##0.00", "en_US").format(int.parse(widget.payment_total))}",
                          style: FunctionHelper.FontTheme(
                              fontSize: 17.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 10,), // Wed Jan 27 2021 22:28:51 GMT+0700
                      Text("You have placed an order and must pay by the date ${DateFormat.yMMMMEEEEd().format(DateTime.now())}  ${DateFormat.jms().format(DateTime.now())}",
                          textAlign: TextAlign.center,
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                _buildBtnAddProduct()
              ],
            )
        ));
  }

  Widget _buildBtnAddProduct() {
    return Center(
      child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.0.w,
            height: 60,
            padding: EdgeInsets.all(10),
            child: FlatButton(
              color: ThemeColor.ColorSale(),
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: () async {
               AppRoute.Home(context);

              },
              child: Text(
                "Back to Main Page",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            width: 40.0.w,
            height: 60,
            padding: EdgeInsets.all(10),
            child: FlatButton(
              color: ThemeColor.secondaryColor(),
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: () async {
                AppRoute.MyShophistory(context, 0,orderType: "order",callback: true);
              },
              child: Text(
                "Order details",
                style: FunctionHelper.FontTheme(
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class OrderSuccessView extends StatefulWidget {
  final String paymentTotal;
  final OrderData orderData;

  const OrderSuccessView({Key key, this.paymentTotal, this.orderData})
      : super(key: key);
  @override
  _OrderSuccessViewState createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  init() {
    NaiFarmLocalStorage.saveNowPage(0);
    Usermanager().getUser().then((value) {
      Usermanager().getUser().then((value) => context
          .read<CustomerCountBloc>()
          .loadCustomerCount(context, token: value.token));
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.grey.shade300,
              key: _scaffoldKey,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(6.5.h),
                child: AppToobar(
                  isEnableSearch: false,
                  title: "รายละเอียดการสั่งซื้อ",
                  headerType: Header_Type.barNormal,
                  icon: "",
                  onClick: () =>
                      AppRoute.poppageCount(context: context, countpage: 2),
                ),
              ),
              body: WillPopScope(
                onWillPop: () async {
                  AppRoute.poppageCount(context: context, countpage: 2);
                  return false;
                },
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 2.0.h, right: 3.0.w, left: 3.0.w, top: 3.0.h),
                      width: MediaQuery.of(context).size.width,
                      color: ThemeColor.primaryColor(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //   SizedBox(height: 10,),
                          // Text("Order details",
                          //     style: FunctionHelper.fontTheme(
                          //         fontSize: 16.0.sp,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/svg/checkmark.svg',
                                color: Colors.white,
                                width: 6.0.w,
                                height: 6.0.w,
                              ),
                              SizedBox(
                                width: 2.0.w,
                              ),
                              Text(LocaleKeys.order_detail_complete.tr(),
                                  style: FunctionHelper.fontTheme(
                                      fontSize:
                                          (SizeUtil.titleFontSize() + 2).sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                          SizedBox(
                            height: 2.0.h,
                          ),
                          // Text("ยอดชำระเงิน ฿${NumberFormat("#,##0.00", "en_US").format(int.parse(widget.payment_total))}",
                          Text(
                              "${LocaleKeys.order_detail_summary.tr()} ฿${int.parse(widget.paymentTotal)}",
                              style: FunctionHelper.fontTheme(
                                  fontSize: (SizeUtil.titleFontSize() + 1.0).sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          SizedBox(
                            height: 2.0.h,
                          ), // Wed Jan 27 2021 22:28:51 GMT+0700  //${DateFormat.jms().format(DateTime.parse(widget.orderData.requirePaymentAt)
                          //Text("You have placed an order and must pay by the date ${DateFormat.yMMMMEEEEd().format(DateTime.parse(widget.orderData.requirePaymentAt))}",
                          Text(
                              "คุณได้ทำรายการสั่งซื้อสินค้าและต้องชำระเงิน\nภายในวันที่ ${DateFormat('dd-MM-yyyy H:m').format(DateTime.parse(widget.orderData.requirePaymentAt))}",
                              textAlign: TextAlign.center,
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleSmallFontSize().sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    _buildBtnAddProduct()
                  ],
                ),
              ))),
    );
  }

  Widget _buildBtnAddProduct() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 45.0.w,
            height: 8.0.h,
            padding: EdgeInsets.all(10),
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  ThemeColor.colorSale(),
                ),
                overlayColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.3),
                ),
              ),
              onPressed: () async {
                AppRoute.home(context);
              },
              child: Text(
                LocaleKeys.btn_main.tr(),
                style: FunctionHelper.fontTheme(
                    color: Colors.white,
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            width: 45.0.w,
            height: 8.0.h,
            padding: EdgeInsets.all(10),
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
                AppRoute.poppageCount(context: context, countpage: 2);
                AppRoute.orderDetail(context, orderData: widget.orderData);
              },
              child: Text(
                LocaleKeys.order_detail_txt.tr(),
                style: FunctionHelper.fontTheme(
                    color: Colors.white,
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

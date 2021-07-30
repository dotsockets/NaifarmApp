import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class CartBankView extends StatefulWidget {
  final PaymentRespone paymentRespone;
  final String allShopID;
  const CartBankView({Key key, this.paymentRespone, this.allShopID})
      : super(key: key);

  @override
  _CartBankViewState createState() => _CartBankViewState();
}

class _CartBankViewState extends State<CartBankView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int select = 0;
  CartBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = CartBloc(AppProvider.getApplication(context));

      // bloc.paymentList.stream.listen((event) {
      //   if(widget.paymentRespone.data.length==0){
      //     FunctionHelper.alertDialogRetry(context,
      //         title: LocaleKeys.btn_error.tr(),
      //         message:LocaleKeys.search_product_not_found.tr());
      //   }
      // });

      if (widget.paymentRespone.data != null) {
        bloc.paymentList.add(widget.paymentRespone);
      } else {
        bloc.getPaymentList(context, shopIds: widget.allShopID);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.grey.shade200,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(7.5.h),
              child: AppToobar(
                  title: LocaleKeys.select.tr() + LocaleKeys.me_title_pay.tr(),
                  headerType: Header_Type.barNormal,
                  isEnableSearch: false,
                  onClick: () => Navigator.pop(context, null)),
            ),
            body: widget.paymentRespone.data.length > 0
                ? SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Text("Payment",
                        style: FunctionHelper.fontTheme(
                            color: Colors.black,
                            fontSize: SizeUtil.titleSmallFontSize().sp,
                            fontWeight: FontWeight.bold)),*/
                          //SizedBox(height: 8),
                          StreamBuilder(
                              stream: bloc.paymentList.stream,
                              builder: (context, snapshot) {
                                var item = (snapshot.data as PaymentRespone);
                                if (snapshot.hasData && item.data != null) {
                                  return Column(
                                    children: item.data
                                        .asMap()
                                        .map((index, value) {
                                          return MapEntry(
                                              index,
                                              _buildCardBank(
                                                  item: value, index: index));
                                        })
                                        .values
                                        .toList(),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          _buildAddBtn(),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/json/boxorder.json',
                              height: 70.0.w, width: 70.0.w, repeat: false),
                          Text(
                            LocaleKeys.search_product_not_found.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )),
      ),
    );
  }

  Widget _buildCardBank({PaymentData item, int index}) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(1.0.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.0.h),
                        child: item.active
                            ? Image.asset(
                                'assets/images/png/checkmark.png',
                                width: SizeUtil.checkMarkSize().w,
                                height: SizeUtil.checkMarkSize().w,
                                color: ThemeColor.primaryColor(),
                              )
                            : Image.asset(
                                'assets/images/png/uncheckmark.png',
                                width: SizeUtil.checkMarkSize().w,
                                height: SizeUtil.checkMarkSize().w,
                                color: Colors.black.withOpacity(0.5),
                              ),
                      ),
                      SizedBox(
                        width: 1.0.w,
                      ),
                      Row(
                        children: [
                          index == 0
                              ? Image.asset(
                                  'assets/images/png/delivery.png',
                                  width: SizeUtil.checkMarkSize().w,
                                  height: SizeUtil.checkMarkSize().w,
                                )
                              : Image.asset(
                                  'assets/images/png/money_pay.png',
                                  width: SizeUtil.checkMarkSize().w,
                                  height: SizeUtil.checkMarkSize().w,
                                ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          EasyLocalization.of(context).locale ==
                              EasyLocalization.of(context).supportedLocales[0]? FutureBuilder(
                              future: FunctionHelper.translatorText(name: item.name,from: 'th',to: 'en'),
                              builder:
                                  (BuildContext context, AsyncSnapshot<String> text) {

                                return Text("${text.data ?? "${item.name}"}",
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.titleFontSize().sp));
                              }):Text(item.name,
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp)),
                        ],
                      ),
                    ],
                  ),
                  // Container(
                  //   child: Icon(
                  //     Icons.arrow_forward_ios,
                  //     color: Colors.grey.shade500,
                  //   ),
                  // )
                ],
              ),
              onTap: () {
                for (var i = 0; i < bloc.paymentList.value.data.length; i++) {
                  if (bloc.paymentList.value.data[i].id == item.id) {
                    bloc.paymentList.value.data[i].active = true;
                  } else {
                    bloc.paymentList.value.data[i].active = false;
                  }
                }

                bloc.paymentList.add(bloc.paymentList.value);
              },
            )),
        SizedBox(
          height: 1.0.h,
        )
      ],
    );
  }

  Widget _buildAddBtn() {
    return Center(
      child: Container(
        height: 5.0.h,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            padding: MaterialStateProperty.all(EdgeInsets.only(
              left: 20.0.w,
              right: 20.0.w,
            )),
            backgroundColor: MaterialStateProperty.all(
              ThemeColor.secondaryColor(),
            ),
            overlayColor: MaterialStateProperty.all(
              Colors.white.withOpacity(0.3),
            ),
          ),
          onPressed: () async {
            Navigator.pop(context, bloc.paymentList.value);
          },
          child: Text(
            LocaleKeys.btn_confirm.tr(),
            style: FunctionHelper.fontTheme(
                color: Colors.white,
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

// Widget _buildAddBtn({String txtBtn, int indexBtn}) {
//   return ClipRRect(
//     borderRadius: BorderRadius.all(Radius.circular(10)),
//     child: DottedBorder(
//       dashPattern: [5, 5],
//       color: Colors.grey.withOpacity(0.5),
//       strokeWidth: 5,
//       child: InkWell(
//         child: Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: Row(
//             children: [
//               Text(
//                 "+",
//                 style: FunctionHelper.fontTheme(
//                     fontSize: SizeUtil
//                         .titleFontSize()
//                         .sp,
//                     fontWeight: FontWeight.w200),
//               ),
//               SizedBox(
//                 width: 15,
//               ),
//               Text(
//                 txtBtn,
//                 style: FunctionHelper.fontTheme(
//                     color: ThemeColor.primaryColor(),
//                     fontSize: SizeUtil
//                         .titleFontSize()
//                         .sp),
//               ),
//             ],
//           ),
//         ),
//         onTap: () {
//           indexBtn == 0
//               ? AppRoute.SettingCreditAdd(context) // ไม่ได้ใช้
//               : AppRoute.SettingBankAdd(context);
//         },
//       ),
//     ),
//   );
// }
}

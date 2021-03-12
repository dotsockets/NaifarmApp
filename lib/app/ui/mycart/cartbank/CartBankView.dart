import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  const CartBankView({Key key, this.paymentRespone}) : super(key: key);

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
      if (widget.paymentRespone.data != null) {
        bloc.paymentList.add(widget.paymentRespone);
      } else {
        bloc.getPaymentList(
          context,
        );
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
              preferredSize: Size.fromHeight(6.5.h),
              child: AppToobar(
                  title:
                      LocaleKeys.select.tr() + LocaleKeys.me_title_payment.tr(),
                  headerType: Header_Type.barNormal,
                  isEnableSearch: false,
                  onClick: () => Navigator.pop(context, null)),
            ),
            body: SingleChildScrollView(
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
                            ? SvgPicture.asset(
                                'assets/images/svg/checkmark.svg',
                                width: 8.0.w,
                                height: 8.0.w,
                                color: ThemeColor.primaryColor(),
                              )
                            : SvgPicture.asset(
                                'assets/images/svg/uncheckmark.svg',
                                width: 8.0.w,
                                height: 8.0.w,
                                color: Colors.black.withOpacity(0.5),
                              ),
                      ),
                      SizedBox(
                        width: 1.0.w,
                      ),
                      Row(
                        children: [
                          index == 0
                              ? SvgPicture.asset(
                                  'assets/images/svg/delivery.svg',
                                  width: 8.0.w,
                                  height: 8.0.w,
                                )
                              : SvgPicture.asset(
                                  'assets/images/svg/money_pay.svg',
                                  width: 8.0.w,
                                  height: 8.0.w,
                                ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          Text(item.name,
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
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            padding: MaterialStateProperty.all(EdgeInsets.only(
                left: 20.0.w, right: 20.0.w, top: 2.0.h, bottom: 2.0.h)),
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

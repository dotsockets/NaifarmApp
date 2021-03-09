import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:naifarm/app/bloc/Stream/PaymentBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/PaymentObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:sizer/sizer.dart';

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  int checkDeli = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PaymentBloc bloc;
  @override
  void initState() {
    super.initState();
  }

  init() {
    if (bloc == null) {
      bloc = PaymentBloc(AppProvider.getApplication(context));
      bloc.onError.stream.listen((event) {
        Usermanager()
            .getUser()
            .then((value) => bloc.loadPaymentPage(context,token: value.token));
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
      });
      Usermanager()
          .getUser()
          .then((value) => bloc.loadPaymentPage(context,token: value.token));
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
            title: LocaleKeys.me_title_payment.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
            isEnable_Search: false,
          ),
          body: Container(
            padding: SizeUtil.detailProfilePadding(),
            color: Colors.grey.shade300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: bloc.ZipPaymentObject.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: List.generate(
                              (snapshot.data as PaymentObjectCombine)
                                  .paymentRespone
                                  .total, (index) {
                            return Column(
                              children: [
                                _BuildDelivery(
                                    nameDeli:
                                        (snapshot.data as PaymentObjectCombine)
                                            .paymentRespone
                                            .data[index]
                                            .name,
                                    item:
                                        (snapshot.data as PaymentObjectCombine)
                                            .paymentRespone
                                            .data[index]),
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            );
                          }),
                        );
                      } else {
                        return Skeleton.LoaderList(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildDelivery({String nameDeli, PaymentData item}) {
    return Container(
      padding: EdgeInsets.all(2.0.h),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nameDeli,
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
            FlutterSwitch(
              height: SizeUtil.switchHeight(),
              width: SizeUtil.switchWidth(),
              toggleSize: SizeUtil.switchToggleSize(),
              activeColor: Colors.grey.shade200,
              inactiveColor: Colors.grey.shade200,
              toggleColor: item.active
                  ? ThemeColor.primaryColor()
                  : Colors.grey.shade400,
              value: item.active,
              onToggle: (val) {
                //IsSwitch(val);
                for (var index
                    in bloc.ZipPaymentObject.value.paymentRespone.data) {
                  if (item.id == index.id) {
                    index.active = !index.active;
                    if (index.active)
                      Usermanager().getUser().then((value) => bloc.AddPayment(context,
                          paymentMethodId: index.id, token: value.token));
                    else
                      Usermanager().getUser().then((value) =>
                          bloc.DeletePayment(context,
                              paymentMethodId: index.id, token: value.token));
                    break;
                  }
                }

                bloc.ZipPaymentObject.add(bloc.ZipPaymentObject.value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

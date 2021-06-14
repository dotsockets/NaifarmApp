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
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class AddtTrackingNumberView extends StatelessWidget {
  final OrderData orderData;

  AddtTrackingNumberView({Key key, this.orderData}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController trackController = new TextEditingController();
  final trackOnError = BehaviorSubject<String>();
  OrdersBloc bloc;
  init(BuildContext context) {
    bool onDialog = false;

    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      trackOnError.add("");
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            message: event, showbtn: true, title: LocaleKeys.btn_error.tr());
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is bool) {
          onDialog = true;
          FunctionHelper.successDialog(context,
              message: LocaleKeys.dialog_message_success_track.tr(),
              onClick: () {},
              barrierDismissible: false);
          Future.delayed(const Duration(milliseconds: 800), () {
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          });
        }
      });
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
          backgroundColor: Colors.grey.shade200,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.0.h),
            child: AppToobar(
              title: LocaleKeys.history_track.tr(),
              headerType: Header_Type.barcartShop,
              isEnableSearch: false,
              icon: '',
              onClick: () {
                Navigator.pop(context, false);
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 4.0.w, right: 4.0.w, top: 2.0.w),
                      color: Colors.white,
                      child: StreamBuilder(
                        stream: trackOnError.stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return BuildEditText(
                              enableMaxLength: false,
                              maxLength: 5000,
                              borderOpacity: 0.3,
                              hint: LocaleKeys.history_track.tr(),
                              maxLine: 1,
                              controller: trackController,
                              onError: snapshot.data,
                              inputType: TextInputType.text,
                              onChanged: (String char) {
                                if (char.isNotEmpty) {
                                  trackOnError.add("");
                                }
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 4.0.w, right: 4.0.w, top: 2.0.h),
                      color: Colors.white,
                      child: Text(
                        LocaleKeys.history_track_fill.tr(),
                        style: FunctionHelper.fontTheme(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.normal,
                            fontSize: SizeUtil.titleSmallFontSize().sp),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 4.0.w, right: 4.0.w, top: 2.0.w, bottom: 4.0.w),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0.w)),
                            ),
                            width: 2.5.w,
                            height: 2.5.w,
                          ),
                          SizedBox(
                            width: 2.5.w,
                          ),
                          Expanded(
                              child: Text(
                            LocaleKeys.history_track_msg.tr(),
                            style: FunctionHelper.fontTheme(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                                fontSize: SizeUtil.titleSmallFontSize().sp),
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              )),
              buttonActive(context: context, orderData: orderData),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonActive(
      {TextEditingController controller,
      BuildContext context,
      OrderData orderData}) {
    return Center(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(2.0.w),
        child: Center(
          child: TextButton(
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
                ThemeColor.colorSale(),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () {
              if (trackController.text.length > 0) {
                FunctionHelper.confirmDialog(context,
                    message: LocaleKeys.dialog_message_confirm_track.tr(),
                    onCancel: () {
                  Navigator.of(context).pop();
                }, onClick: () {
                  Navigator.of(context).pop();
                  Usermanager().getUser().then((value) => bloc.addTracking(
                      context,
                      token: value.token,
                      orderId: orderData.id,
                      trackingId: trackController.text));
                });
              } else {
                trackOnError.add(LocaleKeys.history_track_no.tr());
              }
            },
            child: Text(
              LocaleKeys.order_detail_ship.tr(),
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class DeliveryDropoffView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  OrdersBloc bloc;

  init(BuildContext context) {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        Navigator.pop(context, true);
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.0.h),
            child: AppToobar(
              title: "Drop Off Information ",
              headerType: Header_Type.barcartShop,
              isEnableSearch: false,
              icon: '',
              onClick: () {
                Navigator.pop(context, false);
              },
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    genQR(context),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    itemInfoNearby(context),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    itemInfoDelivery()
                  ],
                )),
                buttonActive(context: context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget genQR(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0.h),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "คุณสามารถนำ QR Code ด้านล่างไปสแกนที่สาขา ที่เคาน์เตอร์",
            textAlign: TextAlign.center,
            style: FunctionHelper.fontTheme(
                color: Colors.black, fontSize: SizeUtil.titleFontSize().sp),
          ),
          SizedBox(
            height: 2.0.h,
          ),
          // QrImage(
          //   data: "642345790",
          //   version: QrVersions.auto,
          //   size: 200.0,
          // ),
          SizedBox(
            height: 2.0.h,
          ),
          Text(
            "642345790",
            style: FunctionHelper.fontTheme(
                color: Colors.black, fontSize: SizeUtil.titleFontSize().sp),
          ),
        ],
      ),
    );
  }

  Widget itemInfoNearby(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      padding: EdgeInsets.all(1.0.w),
      child: ListMenuItem(
        fontWeight: FontWeight.normal,
        icon: "",
        title: "See a branch near you",
        message: "Branch 1, Mueang Chiang Mai District ",
        onClick: () {
          _showMyDialog(context);
        },
      ),
    );
  }

  Widget itemInfoDelivery() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      padding: EdgeInsets.all(1.0.w),
      child: ListTile(
          title: Text(
            "Delivery address ",
            style: FunctionHelper.fontTheme(
                color: Colors.black, fontSize: SizeUtil.titleFontSize().sp),
          ),
          subtitle: Text(
            "39 Srichandorn Road, Chang Khlan Subdistrict, Mueang District, Chiang Mai 50100 ",
            style: FunctionHelper.fontTheme(
                color: Colors.grey.shade500,
                fontSize: SizeUtil.titleFontSize().sp),
          )),
    );
  }

  Widget buttonActive({BuildContext context}) {
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
              FunctionHelper.confirmDialog(context,
                  message:
                      "สำคัญ! คุณสามารถทำการ Drop Off พัสดุของคุณได้ที่ สาขาใกล้บ้านคุณ",
                  onCancel: () {
                Navigator.of(context).pop();
              }, onClick: () {});
            },
            child: Text(
              "Confirm ",
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

  Future<void> _showMyDialog(BuildContext context) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: InkWell(
            onTap: () {
              // onClick();
            },
            child: Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: ThemeColor.dialogprimaryColor(context),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                              child: Text(
                            "เลือกสาขาในการจัดส่ง",
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1)),
                                  ),
                                  padding: const EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "สาขา 1 อำเภอเมือง เชัยงใหม่",
                                    style: FunctionHelper.fontTheme(
                                        color: Colors.grey.shade700,
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1)),
                                  ),
                                  padding: const EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "สาขา 1 อำเภอเมือง เชัยงใหม่",
                                    style: FunctionHelper.fontTheme(
                                        color: Colors.grey.shade700,
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 1)),
                                  ),
                                  padding: const EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "สาขา 1 อำเภอเมือง เชัยงใหม่",
                                    style: FunctionHelper.fontTheme(
                                        color: Colors.grey.shade700,
                                        fontSize: SizeUtil.titleFontSize().sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              )
            ])),
          ),
        );
      },
    );
  }
}

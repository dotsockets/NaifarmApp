import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/SystemRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class TransferPayMent extends StatefulWidget {
  final OrderData orderData;

  const TransferPayMent({Key key, this.orderData}) : super(key: key);
  @override
  _TransferPayMentState createState() => _TransferPayMentState();
}

class _TransferPayMentState extends State<TransferPayMent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File fileImage;

  bool onDialog = false;
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
        //Navigator.of(context).pop();
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
        //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        onDialog = true;
        FunctionHelper.successDialog(context,
            message: LocaleKeys.dialog_message_success_slip.tr(), onClick: () {
          if (onDialog) {
            Navigator.pop(context, true);
          }
        });
      });

      NaiFarmLocalStorage.getSystemCache().then((value) {
        if (value != null) {
          bloc.systemRespone.add(value);
        }
        bloc.getSystem(context);
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
            title: LocaleKeys.order_detail_payment_info.tr(),
            headerType: Header_Type.barNormal,
            isEnableSearch: false,
            icon: '',
            onClick: () {
              Navigator.pop(context, false);
              //AppRoute.PoppageCount(context: context,countpage: 1);
            },
          ),
          body: StreamBuilder(
              stream: bloc.systemRespone.stream,
              builder: (context, snapshot) {
                var systemRes = snapshot.data as SystemRespone;
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: SizeUtil.paddingMenu().w,
                        ),
                        infoMessage(
                            title: "1",
                            message:
                                "หากท่านต้องการชำระเงินผ่านตู้ ATM หรือหน้าเคาท์เตอร์ธนาคาร ท่านสามารถเลือก ATM Bill Payment ใน Naifarm ได้เช่นกัน ซึ่งวิธีนี้ท่านไม่จำเป็นต้องอัพโหลดเอกสารการชำระเงิน และสามารถรอการยืนยันการชำระเงินได้รวดเร็วกว่า หากท่านยืนยันที่จะเลือกช่องทางนี้ ท่านสามารถชำระเงินผ่าน intenet/mobile banking มายังบัญชีธนาคารของ Naifarm"),
                        cardBank(index: 0, systemRespone: systemRes),
                        // cardBank1(index: 1),
                        cardQr(systemRes != null
                            ? systemRes.bankAccountMobile
                            : ""),
                        infoMessage(
                            title: "2",
                            message:
                                "เก็บหลักฐานการโอนเงินและอัพโหลดภายใน 14-01-2021",
                            paddingBottom: false),
                        infoMessage(
                            title: "3",
                            message:
                                "เพื่อความรวดเร็วในการยืนยันการชำระเงินของท่าน ขอแนะนำให้ท่านอัพโหลดหลักฐานการชำระเงินที่ท่านได้รับจาก mobile banking application หรือ internet banking แทนการอัพโหลดหลักฐานประเภทอื่น ซึ่งอาจทำให้ตรวจสอบการชำระเงินล่าช้า"),
                        buttonItem(systemRespone: systemRes)
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget cardBank({int index, SystemRespone systemRespone}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1),
            bottom: BorderSide(
                color: Colors.grey.withOpacity(0.6),
                width: index != 0 ? 1 : 0)),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            width: 5.0.w,
            height: 5.0.w,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h, left: 3.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (systemRespone == null ? "" : systemRespone.bankAccount) ??
                        LocaleKeys.search_product_not_found.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    LocaleKeys.bank_accountName.tr() +
                        ": " +
                        ((systemRespone == null
                                ? ""
                                : systemRespone.bankAccountName) ??
                            LocaleKeys.search_product_not_found.tr()),
                    style: FunctionHelper.fontTheme(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      LocaleKeys.bank_accountNumber.tr() + ": ",
                                  style: FunctionHelper.fontTheme(
                                      fontSize:
                                          SizeUtil.spanTitleSmallFontSize().sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black.withOpacity(0.5))),
                              TextSpan(
                                  text: (systemRespone == null
                                          ? ""
                                          : systemRespone.bankAccountName) ??
                                      LocaleKeys.search_product_not_found.tr(),
                                  style: FunctionHelper.fontTheme(
                                      fontSize:
                                          (SizeUtil.spanTitleFontSize()).sp,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeColor.colorSale())),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          child: Text(
                            "${LocaleKeys.btn_copy.tr()}",
                            style: FunctionHelper.fontTheme(
                                color: ThemeColor.secondaryColor(),
                                fontSize: SizeUtil.titleSmallFontSize().sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          FlutterClipboard.copy((systemRespone == null
                                  ? ""
                                  : systemRespone.bankAccountName))
                              .then((value) {
                            FunctionHelper.snackBarShow(
                              scaffoldKey: _scaffoldKey,
                              context: context,
                              message: LocaleKeys.dialog_message_copied.tr(),
                            );
                            /*FunctionHelper.alertDialogShop(context,
                                title: LocaleKeys.btn_error.tr(),
                                message: LocaleKeys.btn_copy.tr());*/
                          });
                        },
                      ),
                      SizedBox(
                        width: 3.0.w,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardBank1({int index}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1),
            bottom: BorderSide(
                color: Colors.grey.withOpacity(0.6),
                width: index != 0 ? 1 : 0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 5.0.w,
            height: 5.0.w,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h, left: 3.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "กสิกร",
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    "ปิดปรับปรุงชั่วคราว",
                    style: FunctionHelper.fontTheme(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget cardQr(String payNumber) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 5.0.w,
            height: 5.0.w,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h, left: 3.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.order_detail_pay_qr.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  /*QrImage(
                    data: "468 0601 709",
                    version: QrVersions.auto,
                    size: 150.0,
                  ),*/
                  payNumber != ""
                      ? Image.network("https://promptpay.io/$payNumber/" +
                          widget.orderData.grandTotal.toString())
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buttonItem({SystemRespone systemRespone}) {
    return Container(
      padding: EdgeInsets.all(3.0.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1),
            bottom: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1)),
      ),
      child: Column(
        children: [
          Container(
            width: 80.0.w,
            height: 5.0.h,
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  widget.orderData.orderStatusId == 1 &&
                          widget.orderData.itemCount ==
                              widget.orderData.items.length &&
                          systemRespone != null &&
                          systemRespone.bankAccountNumber != null
                      ? ThemeColor.secondaryColor()
                      : Colors.grey,
                ),
                overlayColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.3),
                ),
              ),
              onPressed: () {
                if (widget.orderData.orderStatusId == 1 &&
                    widget.orderData.itemCount ==
                        widget.orderData.items.length &&
                    systemRespone != null &&
                    systemRespone.bankAccountNumber != null) {
                  captureImage(ImageSource.gallery);
                }
              },
              child: Text(
                widget.orderData.image.length == 0
                    ? "${LocaleKeys.payment_method_upload_slip.tr()}"
                    : "${LocaleKeys.payment_method_update_slip.tr()}",
                style: FunctionHelper.fontTheme(
                    color: Colors.white,
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(
            height: 1.5.h,
          ),
          widget.orderData.image.length == 0
              ? Container(
                  width: 80.0.w,
                  height: 5.0.h,
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "${LocaleKeys.payment_method_no_slip.tr()}",
                      style: FunctionHelper.fontTheme(
                          color: Colors.white,
                          fontSize: SizeUtil.titleSmallFontSize().sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  Widget infoMessage(
      {String title, String message, bool paddingBottom = true}) {
    return Container(
      padding: EdgeInsets.only(
          bottom: paddingBottom ? 1.0.h : 0.0.h,
          left: 1.0.h,
          right: 1.0.h,
          top: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 2.0.w),
            padding: EdgeInsets.all(1.0.h),
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Text(
              title,
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 0.8.h),
              child: Text(
                message,
                style: FunctionHelper.fontTheme(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future captureImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile != null) {
      fileImage = File(pickedFile.path);
      Usermanager().getUser().then((value) => bloc.uploadImage(context,
          imageFile: fileImage,
          imageableType: "order",
          imageableId: widget.orderData.id,
          token: value.token));
    } else {
      print('No image selected.');
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/RadioWidget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class CouponAddView extends StatefulWidget {
  final CouponData couponEdit;
  final int shopId;
  CouponAddView({Key key, @required this.shopId, this.couponEdit})
      : super(key: key);

  @override
  _CouponAddViewState createState() => _CouponAddViewState();
}

class _CouponAddViewState extends State<CouponAddView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController minOrderAmountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController quantityPerCustomerController = TextEditingController();
  CartBloc bloc;
  CouponData couponData = new CouponData(active: 1, type: "Amount");
  List<RadioData> conponTypeRadioModel = [
    RadioData("Amount", "Amount"),
    RadioData("Percent", "Percent"),
  ];
  final isEnable = BehaviorSubject<bool>();
  final startingTime = BehaviorSubject<String>();
  final endingTime = BehaviorSubject<String>();
  final isActive = BehaviorSubject<bool>();

  @override
  void dispose() {
    isEnable.close();
    startingTime.close();
    endingTime.close();
    isActive.close();
    super.dispose();
  }

  _init() {
    if (bloc == null) {
      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        if (event != null) {
          var result = (event as CouponResponse);
          couponData.id = result.data.first.id;
          Navigator.pop(context, true);
        }
      });
    }
    couponData.shippingZoneId = widget.shopId;
    isEnable.add(false);
    if (widget.couponEdit != null) {
      nameController.text = widget.couponEdit.name;
      codeController.text = widget.couponEdit.code;
      descriptionController.text = widget.couponEdit.description;
      valueController.text = widget.couponEdit.value.toString();
      quantityController.text = widget.couponEdit.quantity.toString();
      quantityPerCustomerController.text =
          widget.couponEdit.quantityPerCustomer.toString();
      minOrderAmountController.text =
          widget.couponEdit.minOrderAmount.toString();
      couponData = new CouponData(
        id: widget.couponEdit.id,
        shippingZoneId: widget.couponEdit.couponShippingZone.shippingZone.id,
        name: widget.couponEdit.name,
        code: widget.couponEdit.code,
        description: widget.couponEdit.description,
        value: widget.couponEdit.value,
        minOrderAmount: widget.couponEdit.minOrderAmount,
        type: widget.couponEdit.type == "amount" ? "Amount" : "Percent",
        quantity: widget.couponEdit.quantity,
        quantityPerCustomer: widget.couponEdit.quantityPerCustomer,
        startingTime: DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(widget.couponEdit.startingTime)),
        endingTime: DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(widget.couponEdit.endingTime)),
        active: widget.couponEdit.active,
      );
      isActive.add(widget.couponEdit.active == 1 ? true : false);
      startingTime.add(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(widget.couponEdit.startingTime)));
      endingTime.add(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(widget.couponEdit.endingTime)));
    } else {
      isActive.add(true);
      startingTime.add("");
      endingTime.add("");
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
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [
                Container(
                  height: 6.5.h,
                  child: AppToobar(
                    title: LocaleKeys.coupon_coupon_add.tr(),
                    icon: "",
                    isEnableSearch: false,
                    headerType: Header_Type.barNormal,
                    onClick: () => Navigator.pop(context, true),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(right: 20, top: 20, left: 20),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildEditText(
                                head: LocaleKeys.coupon_coupon_name.tr() + " *",
                                enableMaxLength: true,
                                hint: LocaleKeys.fill.tr() +
                                    LocaleKeys.coupon_coupon_name.tr(),
                                maxLength: 120,
                                controller: nameController,
                                inputType: TextInputType.text,
                                onChanged: (String str) {
                                  checkEnable();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              BuildEditText(
                                head:
                                    LocaleKeys.coupon_coupon_code.tr() + " * ",
                                enableMaxLength: true,
                                hint: LocaleKeys.fill.tr() +
                                    LocaleKeys.coupon_coupon_code.tr(),
                                maxLength: 120,
                                controller: codeController,
                                inputType: TextInputType.text,
                                onChanged: (String str) {
                                  checkEnable();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              BuildEditText(
                                head: LocaleKeys.coupon_coupon_description.tr(),
                                enableMaxLength: true,
                                maxLength: 5000,
                                hint: LocaleKeys.fill.tr() +
                                    LocaleKeys.coupon_coupon_description.tr(),
                                maxLine: 5,
                                controller: descriptionController,
                                inputType: TextInputType.text,
                                onChanged: (String str) {
                                  checkEnable();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              RadioWidget(
                                data: conponTypeRadioModel,
                                initailValue: couponData.type,
                                onSelected: (value) {
                                  couponData.type = value;
                                  checkEnable();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              BuildEditText(
                                head:
                                    LocaleKeys.coupon_coupon_values.tr() + " *",
                                hint: "0",
                                inputType: TextInputType.number,
                                controller: valueController,
                                onChanged: (String str) {
                                  checkEnable();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              BuildEditText(
                                head: LocaleKeys.coupon_coupon_minorder.tr() +
                                    " *",
                                hint: "0",
                                inputType: TextInputType.number,
                                controller: minOrderAmountController,
                                onChanged: (String str) {
                                  checkEnable();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              BuildEditText(
                                head: LocaleKeys.coupon_coupon_quantity.tr() +
                                    " *",
                                hint: "0",
                                inputType: TextInputType.number,
                                controller: quantityController,
                                onChanged: (String str) {
                                  checkEnable();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              BuildEditText(
                                head: LocaleKeys
                                        .coupon_coupon_quantityPerCustomer
                                        .tr() +
                                    " *",
                                hint: "0",
                                inputType: TextInputType.number,
                                controller: quantityPerCustomerController,
                                onChanged: (String str) {
                                  checkEnable();
                                },
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => {
                            Platform.isAndroid
                                ? FunctionHelper.selectDateAndroid(
                                    context,
                                    DateTime.parse(couponData.startingTime != null
                                        ? couponData.startingTime
                                        : DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now())),
                                    isSetMaxDate: false,
                                    onDateTime: (DateTime date) {
                                    if (date != null)
                                      couponData.startingTime =
                                          DateFormat('yyyy-MM-dd').format(date);
                                    startingTime.add(
                                        DateFormat('yyyy-MM-dd').format(date));
                                    checkEnable();
                                  })
                                : FunctionHelper.showPickerDateIOS(
                                    context,
                                    DateTime.parse(
                                        couponData.startingTime != null
                                            ? couponData.startingTime
                                            : DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now())),
                                    isSetMaxDate: false,
                                    onTap: (DateTime date) {
                                    if (date != null)
                                      couponData.startingTime =
                                          DateFormat('yyyy-MM-dd').format(date);
                                    startingTime.onAdd(
                                        DateFormat('yyyy-MM-dd').format(date));
                                    checkEnable();
                                  })
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.coupon_coupon_startdate.tr(),
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.titleFontSize().sp),
                                  ),
                                  Row(
                                    children: [
                                      StreamBuilder(
                                          stream: startingTime.stream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snap) {
                                            if (snap.hasData) {
                                              return Text(
                                                snap.data,
                                                style: FunctionHelper.fontTheme(
                                                    fontSize:
                                                        SizeUtil.titleFontSize()
                                                            .sp),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey.withOpacity(0.7),
                                        size: SizeUtil.ratingSize().w,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => {
                            Platform.isAndroid
                                ? FunctionHelper.selectDateAndroid(
                                    context,
                                    DateTime.parse(couponData.endingTime != null
                                        ? couponData.endingTime
                                        : DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now())),
                                    isSetMaxDate: false,
                                    onDateTime: (DateTime date) {
                                    if (date != null) {
                                      couponData.endingTime =
                                          DateFormat('yyyy-MM-dd').format(date);
                                      endingTime.add(DateFormat('yyyy-MM-dd')
                                          .format(date));
                                      checkEnable();
                                    }
                                  })
                                : FunctionHelper.showPickerDateIOS(
                                    context,
                                    DateTime.parse(couponData.endingTime != null
                                        ? couponData.endingTime
                                        : DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now())),
                                    isSetMaxDate: false,
                                    onTap: (DateTime date) {
                                    if (date != null) {
                                      couponData.endingTime =
                                          DateFormat('yyyy-MM-dd').format(date);
                                      endingTime.add(DateFormat('yyyy-MM-dd')
                                          .format(date));
                                      checkEnable();
                                    }
                                  })
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocaleKeys.coupon_coupon_enddate.tr(),
                                    style: FunctionHelper.fontTheme(
                                        fontSize: SizeUtil.titleFontSize().sp),
                                  ),
                                  Row(
                                    children: [
                                      StreamBuilder(
                                          stream: endingTime.stream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snap) {
                                            if (snap.hasData) {
                                              return Text(
                                                snap.data,
                                                style: FunctionHelper.fontTheme(
                                                    fontSize:
                                                        SizeUtil.titleFontSize()
                                                            .sp),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey.withOpacity(0.7),
                                        size: SizeUtil.ratingSize().w,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            margin: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.my_product_sell_open.tr(),
                                  style: FunctionHelper.fontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp),
                                ),
                                StreamBuilder(
                                    stream: isActive.stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snap) {
                                      if (snap.hasData) {
                                        return FlutterSwitch(
                                          height: SizeUtil.switchHeight(),
                                          width: SizeUtil.switchWidth(),
                                          toggleSize:
                                              SizeUtil.switchToggleSize(),
                                          activeColor: snap.data
                                              ? ThemeColor.primaryColor()
                                              : Colors.grey.shade200,
                                          inactiveColor: Colors.grey.shade200,
                                          value: couponData.active == 1
                                              ? true
                                              : false,
                                          onToggle: (val) {
                                            couponData.active = val ? 1 : 0;
                                            isActive.add(val);
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey.shade300,
                  height: 80,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: cancleButton(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        StreamBuilder(
                            stream: isEnable.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snap) {
                              if (snap.hasData) {
                                return Expanded(
                                  child: saveButton(snap.data),
                                );
                              } else {
                                return Expanded(
                                  child: saveButton(false),
                                );
                              }
                            }),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkEnable() {
    if (nameController.text != "" &&
        codeController.text != "" &&
        descriptionController.text != "" &&
        (valueController.text == "" ? 0 : int.parse(valueController.text)) !=
            0 &&
        (quantityController.text == ""
                ? 0
                : int.parse(quantityController.text)) !=
            0 &&
        minOrderAmountController.text != "" &&
        (quantityPerCustomerController.text == ""
                ? 0
                : int.parse(quantityPerCustomerController.text)) !=
            0 &&
        (couponData.startingTime ?? "") != "" &&
        (couponData.endingTime ?? "") != "") {
      isEnable.add(true);
    } else {
      isEnable.add(false);
    }
  }

  Widget saveButton(bool isEnable) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(80.0.w, 50.0),
        ),
        backgroundColor: MaterialStateProperty.all(
          isEnable ? ThemeColor.secondaryColor() : Colors.grey.shade400,
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        if (isEnable) {
          CouponData saveData = new CouponData(
            id: couponData.id,
            shippingZoneId: couponData.shippingZoneId,
            name: nameController.text,
            code: codeController.text,
            description: descriptionController.text,
            value: int.parse(valueController.text),
            minOrderAmount: int.parse(minOrderAmountController.text),
            type: couponData.type,
            quantity: int.parse(quantityController.text),
            quantityPerCustomer: int.parse(quantityPerCustomerController.text),
            startingTime:
                DateTime.parse(couponData.startingTime).toIso8601String(),
            endingTime: DateTime.parse(couponData.endingTime).toIso8601String(),
            active: couponData.active,
          );
          if ((saveData.id ?? 0) > 0) {
            Usermanager().getUser().then((value) {
              bloc.updateCoupon(
                  context: context, token: value.token, updateData: saveData);
            });
          } else {
            Usermanager().getUser().then((value) {
              bloc.addCoupon(
                  context: context, token: value.token, addData: saveData);
            });
          }
        }
      },
      child: Text(
        LocaleKeys.btn_save.tr(),
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget cancleButton() {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(80.0.w, 50.0),
        ),
        backgroundColor: MaterialStateProperty.all(
          ThemeColor.colorSale(),
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      child: Text(
        LocaleKeys.cart_del.tr(),
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleSmallFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}

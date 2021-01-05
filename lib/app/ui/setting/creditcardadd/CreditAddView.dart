

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class CreditAddView extends StatefulWidget {
  @override
  _CreditAddViewState createState() => _CreditAddViewState();
}

class _CreditAddViewState extends State<CreditAddView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController exController = TextEditingController();
  TextEditingController numCardController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController detailAddrController = TextEditingController();
  bool checkKeyBoard = false;
  String errorNameTxt = "",errorDetailTxt = "",errorExTxt = "",errorCvvTxt = "";


  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          checkKeyBoard = visible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title:  LocaleKeys.card_add_toobar.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildEditCard(
                            head: LocaleKeys.card_name.tr(),
                            hint:   LocaleKeys.set_default.tr()+LocaleKeys.card_name.tr(),controller: nameController),

                        Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.card_number.tr(),
                                style: FunctionHelper.FontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(LocaleKeys.card_img.tr(),
                                        style: FunctionHelper.FontTheme(
                                            fontSize: SizeUtil.titleFontSize().sp,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.camera_alt_outlined)
                                  ],
                                ),
                                onTap: () async {
                                  var status = await Permission.camera.request();
                                  if (status == PermissionStatus.granted) {
                                    //scanCard();
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        _buildLine(),
                        _buildDropDown(
                            title:  LocaleKeys.card_type.tr(), list: ["VISA", "VISA2"]),
                        _buildEditCard(head:  LocaleKeys.card_number.tr(), hint: LocaleKeys.card_number.tr(),controller: numCardController),
                        _buildEditCard(head:  LocaleKeys.card_exp.tr(), hint: "MM/YY",controller: exController),
                        _buildEditCard(head: "CVV", hint: "?",controller: cvvController),
                        _buildDropDown(
                            title: LocaleKeys.address_province.tr(),
                            list: ["กรุงเทพมหานคร", "เชียงใหม่"]),
                        _buildDropDown(
                            title: LocaleKeys.address_city.tr(), list: ["ขลุง", "ขลุง"]),
                        _buildDropDown(title: LocaleKeys.address_postal.tr(), list: ["10400"]),
                        _buildEditCard(
                            head:
                            LocaleKeys.address_detail.tr(),
                            hint: "612/399 A space condo ชั้น 4",controller: detailAddrController),
                        Container(
                          color: Colors.white, height: 20,)
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: checkKeyBoard ? false : true,
                  child: _buildButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildError({String errorTxt}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      color: Colors.white,
      child: Visibility(
        child: Text(
          errorTxt,
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp, color: Colors.grey),
        ),
        visible: errorTxt != "" ? true : false,
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        height: 0.8,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildEditCard({String head, String hint,TextEditingController controller}) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      color: Colors.white,
      child: BuildEditText(
          head: head,

          EnableMaxLength: false,
          hint: hint,
          controller: controller,
          inputType: TextInputType.text),
    );
  }

  Widget _buildDropDown({String title, List<String> list}) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: FunctionHelper.FontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp, color: Colors.black)),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey)),
              child: CustomDropdownList(
                title: "ประเภทบัตร",
                dataList: list,
                txtSelect: list[0],
              ))
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        color: Colors.grey.shade300,
        child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: _buildButtonItem(btnTxt: LocaleKeys.save_btn.tr())));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return FlatButton(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: nameController.text.isNotEmpty&&exController.text.isNotEmpty&&cvvController.text.isNotEmpty&&detailAddrController.text.isNotEmpty
          ?ThemeColor.ColorSale():Colors.grey.shade400,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () { _checkError();},
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _checkError(){

  }






}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:sizer/sizer.dart';

class BankAddView extends StatefulWidget {
  @override
  _BankAddViewState createState() => _BankAddViewState();
}

class _BankAddViewState extends State<BankAddView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  String errorIdTxt = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(7.0.h),
            child: AppToobar(
              title: LocaleKeys.bank_add_toobar.tr(),
              icon: "",
              headerType: Header_Type.barNormal,
            ),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditCard(
                      head: LocaleKeys.bank_name_account.tr(),
                      hint: LocaleKeys.set_default.tr() +
                          LocaleKeys.my_profile_fullname.tr(),
                      controller: nameController,
                      type: TextInputType.text),
                  _buildEditCard(
                      head: LocaleKeys.bank_id_card.tr(),
                      hint: LocaleKeys.set_default.tr() +
                          LocaleKeys.bank_id_card.tr(),
                      controller: idController,
                      type: TextInputType.number),
                  _buildError(errorTxt: errorIdTxt),
                  _buildDropDown(
                      title: LocaleKeys.bank_name.tr(),
                      list: ["ไทยพาณิชย์", "กรุงไทย"],
                      txtSelect: LocaleKeys.bank_select.tr()),
                  Container(
                    color: Colors.white,
                    height: 20,
                  ),
                  _buildButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError({String errorTxt}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20, right: 20),
      color: Colors.white,
      child: Visibility(
        child: Text(
          errorTxt,
          style: FunctionHelper.fontTheme(
              fontSize: SizeUtil.titleSmallFontSize().sp, color: Colors.grey),
        ),
        visible: errorTxt != "" ? true : false,
      ),
    );
  }

  Widget _buildEditCard(
      {String head,
      String hint,
      TextEditingController controller,
      TextInputType type}) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      color: Colors.white,
      child: BuildEditText(
          head: head,
          enableMaxLength: false,
          hint: hint,
          controller: controller,
          inputType: type),
    );
  }

  Widget _buildDropDown({String title, List<String> list, String txtSelect}) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: Colors.black)),
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
                txtSelect: txtSelect,
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
            child: _buildButtonItem(btnTxt: LocaleKeys.btn_save.tr())));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            Size(80.0.w, 6.5.h),
          ),
          backgroundColor: MaterialStateProperty.all(
            nameController.text.isNotEmpty && idController.text.isNotEmpty
                ? ThemeColor.colorSale()
                : Colors.grey.shade400,
          ),
          overlayColor: MaterialStateProperty.all(
            Colors.white.withOpacity(0.3),
          ),
          padding:
              MaterialStateProperty.all(EdgeInsets.only(top: 15, bottom: 15))),
      onPressed: () {
        _checkError();
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.fontTheme(
            color: Colors.white,
            fontSize: SizeUtil.titleFontSize().sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  void _checkError() {
    if (idController.text.length != 13 && idController.text.isNotEmpty) {
      setState(() {
        errorIdTxt = "กรอกเลขบัตรประชาชน 13 หลัก";
      });
    } else {
      errorIdTxt = "";
    }
  }
}

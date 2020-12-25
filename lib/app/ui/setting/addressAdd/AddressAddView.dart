import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressAddView extends StatefulWidget {
  @override
  _AddressAddViewState createState() => _AddressAddViewState();
}

class _AddressAddViewState extends State<AddressAddView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController detailAddrController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorEmailTxt = "", errorPhoneTxt = "";
  bool checkKeyBoard = false;
  bool isSelect = false;

  List<String> listAddrDeli = ["1","2","3",];

  //bool checkError = false;
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
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            title: LocaleKeys.address_add_toobar.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      _buildEditAddr(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildSwitch(head: LocaleKeys.address_default.tr())
                    ]),
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

  Widget _buildEditAddr() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildEditText(
              head: LocaleKeys.my_profile_fullname.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_fullname.tr(),
              controller: nameController,
              inputType: TextInputType.text),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: LocaleKeys.my_profile_email.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_email.tr(),
              controller: emailController,
              inputType: TextInputType.text),
          _buildError(errorTxt: errorEmailTxt),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: LocaleKeys.my_profile_phoneNum.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.set_default.tr()+LocaleKeys.my_profile_phoneNum.tr(),
              controller: phoneController,
              inputType: TextInputType.number),
          _buildError(errorTxt: errorPhoneTxt),
          SizedBox(
            height: 15,
          ),
          _BuildDropdown(
              head: LocaleKeys.select.tr()+LocaleKeys.address_province.tr()+" * ", hint: "ทั่วประเทศ",dataList: listAddrDeli),
          SizedBox(
            height: 15,
          ),
          _BuildDropdown(
              head: LocaleKeys.select.tr()+LocaleKeys.address_city.tr()+" * ", hint: "ทั่วประเทศ",dataList: listAddrDeli),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: LocaleKeys.address_postal.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.select.tr()+LocaleKeys.address_postal.tr(),
              controller: postController,
              inputType: TextInputType.number),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: LocaleKeys.address_detail.tr(),
              EnableMaxLength: false,
              hint: LocaleKeys.set_default.tr()+LocaleKeys.address_detail.tr(),
              controller: detailAddrController,
              inputType: TextInputType.text),
        ],
      ),
    );
  }

  Widget _buildError({String errorTxt}) {
    return Container(
      child: Visibility(
        child: Text(
          errorTxt,
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(), color: Colors.grey),
        ),
        visible: errorTxt != "" ? true : false,
      ),
    );
  }

  Widget _buildSwitch({String head}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()),
          ),
          FlutterSwitch(
            height: 30,
            width: 50,
            toggleSize: 20,
            activeColor: Colors.grey.shade200,
            inactiveColor: Colors.grey.shade200,
            toggleColor:
                isSelect ? ThemeColor.primaryColor() : Colors.grey.shade400,
            value: isSelect ? true : false,
            onToggle: (val) {
              setState(() {
                isSelect = val;
              });
            },
          ),
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
            child: _buildButtonItem(btnTxt: LocaleKeys.confirm_btn.tr())));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return FlatButton(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: nameController.text.isNotEmpty &&
              emailController.text.isNotEmpty &&
              phoneController.text.isNotEmpty &&
              provinceController.text.isNotEmpty &&
              districtController.text.isNotEmpty &&
              postController.text.isNotEmpty &&
              detailAddrController.text.isNotEmpty
          ? ThemeColor.secondaryColor()
          : Colors.grey.shade400,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {
        _checkError();
      },
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
      ),
    );
  }

  void _checkError() {
    //  FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "ไม่ถูกต้อง",context: context);

    if (!validator.email(emailController.text) &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        provinceController.text.isNotEmpty &&
        districtController.text.isNotEmpty &&
        postController.text.isNotEmpty &&
        detailAddrController.text.isNotEmpty) {
      setState(() {
        errorEmailTxt = "อีเมลไม่ถูกต้อง";
      });
    } else {
      errorEmailTxt = "";
    }

    if (!validator.phone(phoneController.text) &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        provinceController.text.isNotEmpty &&
        districtController.text.isNotEmpty &&
        postController.text.isNotEmpty &&
        detailAddrController.text.isNotEmpty) {
      setState(() {
        errorPhoneTxt = "หมายเลขโทรศัพท์ไม่ถูกต้อง";
      });
    } else {
      errorPhoneTxt = "";
    }
  }
  Widget _BuildDropdown({String head, String hint, List<String> dataList}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize()),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black.withOpacity(0.3))),
            child: CustomDropdownList(txtSelect: hint,title: head,dataList: dataList,),
          ),

        ],
      ),
    );
  }
}

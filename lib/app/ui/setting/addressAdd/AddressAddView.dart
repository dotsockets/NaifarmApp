import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:regexed_validator/regexed_validator.dart';

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
            Title: "เพิ่มที่อยู่",
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
                      _buildSwitch(head: "เป็นที่อยู่หลัก")
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
              head: "ชื่อ-นามสกุล",
              EnableMaxLength: false,
              hint: "ระบุชื่อ-นามสกุล",
              controller: nameController,
              inputType: TextInputType.text),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: "อีเมล",
              EnableMaxLength: false,
              hint: "ระบุอีเมล",
              controller: emailController,
              inputType: TextInputType.text),
          _buildError(errorTxt: errorEmailTxt),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: "หมายเลขโทรศัพท์",
              EnableMaxLength: false,
              hint: "ระบุหมายเลขโทรศัพท์",
              controller: phoneController,
              inputType: TextInputType.number),
          _buildError(errorTxt: errorPhoneTxt),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: "จังหวัด",
              EnableMaxLength: false,
              hint: "เลือกจังหวัด",
              controller: provinceController,
              inputType: TextInputType.text),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: "เขต/อำเภอ",
              EnableMaxLength: false,
              hint: "เลือกเขต/อำเภอ",
              controller: districtController,
              inputType: TextInputType.text),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: "รหัสไปรษณีย์",
              EnableMaxLength: false,
              hint: "เลือกรหัสไปรษณีย์",
              controller: postController,
              inputType: TextInputType.number),
          SizedBox(
            height: 15,
          ),
          BuildEditText(
              head: "รายละเอียดที่อยู่ (ห้อง, บ้านเลขที่, ตึก, ถนน)",
              EnableMaxLength: false,
              hint: "ระบุรายละเอียด",
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
          style: FunctionHelper.FontTheme(fontSize: 14, color: Colors.grey),
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
            style: FunctionHelper.FontTheme(fontSize: 16),
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
            child: _buildButtonItem(btnTxt: "ยืนยัน")));
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
        style: FunctionHelper.FontTheme(fontSize: 20, fontWeight: FontWeight.w500),
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
}

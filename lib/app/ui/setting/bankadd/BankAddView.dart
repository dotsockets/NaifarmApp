import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';

class BankAddView extends StatefulWidget {
  @override
  _BankAddViewState createState() => _BankAddViewState();
}

class _BankAddViewState extends State<BankAddView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  String errorNameTxt = "", errorIdTxt = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppToobar(
            Title: "เพิ่มบัญชีธนาคาร",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditCard(
                      head: "ชื่อ-นามสกุล ตามที่ปรากฎในบัญชีธนาคาร",
                      hint: "ระบุชื่อ-นามสกุล",
                      controller: nameController,
                      type: TextInputType.text),
                  _buildError(errorTxt: errorNameTxt),
                  _buildEditCard(
                      head: "เลขบัตรประชาชน",
                      hint: "ระบุเลขบัตรประชาชน",
                      controller: idController,
                      type: TextInputType.number),
                  _buildError(errorTxt: errorIdTxt),
                  _buildDropDown(
                      title: "ชื่อธนาคาร",
                      list: ["ไทยพาณิชย์", "กรุงไทย"],
                      txtSelect: "เลือกธนาคาร"),
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
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      color: Colors.white,
      child: Visibility(
        child: Text(
          errorTxt,
          style: FunctionHelper.FontTheme(fontSize: 14, color: Colors.grey),
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
          EnableMaxLength: false,
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
              style: FunctionHelper.FontTheme(
                  fontSize: ScreenUtil().setSp(45), color: Colors.black)),
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
            child: _buildButtonItem(btnTxt: "บันทึก")));
  }

  Widget _buildButtonItem({String btnTxt}) {
    return FlatButton(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: nameController.text.isNotEmpty && idController.text.isNotEmpty
          ? ThemeColor.ColorSale()
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
    if (nameController.text.isEmpty) {
      setState(() {
        errorNameTxt = "กรอกชื่อ-นามสกุล";
      });
    } else {
      errorNameTxt = "";
    }
    if (idController.text.isEmpty) {
      setState(() {
        errorIdTxt = "กรอกเลขบัตรประชาชน";
      });
    } else {
      if (idController.text.length != 13) {
        setState(() {
          errorIdTxt = "กรอกเลขบัตรประชาชน 13 หลัก";
        });
      } else {
        errorIdTxt = "";
      }
    }
  }
}

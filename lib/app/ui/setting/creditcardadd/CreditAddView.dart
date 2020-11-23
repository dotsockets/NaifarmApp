import 'package:card_scanner/card_scanner.dart';
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

class CreditAddView extends StatefulWidget {
  @override
  _CreditAddViewState createState() => _CreditAddViewState();
}

class _CreditAddViewState extends State<CreditAddView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController exController = TextEditingController();
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
            Title: "เพิ่มบัตรเครดิต/บัตรเครดิต",
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
                            head: "ชื่อที่ปรากฎบนบัตร",
                            hint: "ระบุชื่อที่ปรากฎบนบัตร",controller: nameController),
                        _buildError(errorTxt: errorNameTxt),
                        Container(
                          padding: EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 10),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "หมายเลขบัตรเครดิต",
                                style: FunctionHelper.FontTheme(
                                    fontSize: 19, fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text("ถ่ายรูปบัตร",
                                        style: FunctionHelper.FontTheme(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.camera_alt_outlined)
                                  ],
                                ),
                                onTap: () async {
                                  // var cardDetails = await CardScanner.scanCard();
                                  //
                                  // print(cardDetails);
                                },
                              )
                            ],
                          ),
                        ),
                        _buildLine(),
                        _buildDropDown(
                            title: "ประเภทบัตร", list: ["VISA", "VISA2"]),
                        _buildEditCard(head: "วันหมดอายุ", hint: "MM/YY",controller: exController),
                        _buildError(errorTxt: errorExTxt),
                        _buildEditCard(head: "CVV", hint: "?",controller: cvvController),
                        _buildError(errorTxt: errorCvvTxt),
                        _buildDropDown(
                            title: "จังหวัด",
                            list: ["กรุงเทพมหานคร", "เชียงใหม่"]),
                        _buildDropDown(
                            title: "เขต/อำเภอ", list: ["ขลุง", "ขลุง"]),
                        _buildDropDown(title: "รหัสไปรษณีย์", list: ["10400"]),
                        _buildEditCard(
                            head:
                                "รายละเอียดที่อยู่ (ห้อง, บ้านเลขที่, ตึก, ถนน)",
                            hint: "612/399 A space condo ชั้น 4",controller: detailAddrController),
                        _buildError(errorTxt: errorDetailTxt),
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
          style: FunctionHelper.FontTheme(fontSize: 14, color: Colors.grey),
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
            child: _buildButtonItem(btnTxt: "บันทึก")));
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
        style: FunctionHelper.FontTheme(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
  void _checkError(){
    if(nameController.text.isEmpty){
      setState(() {
        errorNameTxt = "กรอกชื่อที่ปรากฎบนบัตร";
      });
    }else{errorNameTxt = "";}


    if(detailAddrController.text.isEmpty){
      setState(() {
        errorDetailTxt = "กรอกรายละเอียดที่อยู๋";
      });
    }else{errorDetailTxt = "";}


    if(exController.text.isEmpty){
      setState(() {
        errorExTxt = "กรอกวันหมดอายุ";
      });
    }else{errorExTxt = "";}

    if(cvvController.text.isEmpty){
      setState(() {
        errorCvvTxt = "กรอก CVV";
      });
    }else{errorCvvTxt = "";}
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class DeliveryCostView extends StatefulWidget {
  @override
  _DeliveryCostViewState createState() => _DeliveryCostViewState();
}

class _DeliveryCostViewState extends State<DeliveryCostView> {
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool checkKeyBoard = false;
  TextEditingController weightProductController = TextEditingController();
  TextEditingController widthProductController = TextEditingController();
  TextEditingController longProductController = TextEditingController();
  TextEditingController heightProductController = TextEditingController();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          checkKeyBoard= visible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          color: Colors.grey.shade300,
          child: Column(
            children: [
              Container(
                  child: AppToobar(
                    Title: "ค่าขนส่ง",
                    icon: "",
                    header_type: Header_Type.barNormal,
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BuildEditText(head: "น้ำหนักสินค้า (kg)", hint: "ระบุความกว้าง",controller: weightProductController),
                      _BuildSpace(),

                      _BuildHeadText(head: "ขนาดสินค้า"),
                      _BuildEditText(head: "กว้าง (cm)", hint: "ระบุความกว้าง",controller: widthProductController),
                      _BuildEditText(head: "ยาว (cm)", hint: "ระบุความยาว",controller: longProductController),
                      _BuildEditText(head: "สูง (cm)", hint: "ระบุความสูง",controller: heightProductController),
                      _BuildSpace(),

                      _BuildHeadText(head: "ค่าขนส่งแต่ละที่"),
                      _BuildSwitchDelivery(head: "Kerry",index: 1,onClick: ()=>setState(()=> isSelect1 = isSelect1?false:true)),
                      _BuildSwitchDelivery(head: "J&T Express",index: 2,onClick: ()=>setState(()=> isSelect2 = isSelect2?false:true)),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: checkKeyBoard?false:true,
                child:  _BuildButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _BuildSpace() {
    return Container(
      height: 20,
      color: Colors.white,
    );
  }
  Widget _BuildHeadText({String head}) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, bottom: 10),
      child: Text(
        head,
        style: FunctionHelper.FontTheme(fontSize: 16),
      ),
    );
  }
  Widget _BuildSwitchDelivery({String head,int index,Function() onClick}) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 20, bottom: 10,right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(head, style: FunctionHelper.FontTheme(fontSize: 18),
          ),Row(
            children: [
              Container(
                  child: Text("ระบุน้ำหนักสินค้า  ", style: FunctionHelper.FontTheme(fontSize: 16,color: ThemeColor.ColorSale()))),
              FlutterSwitch(
                width: 50.0,
                height: 30.0,
                toggleSize: 25.0,
                activeColor: Colors.grey.shade200,
                inactiveColor: Colors.grey.shade200,
                toggleColor: index==1?isSelect1?ThemeColor.primaryColor():Colors.black.withOpacity(0.3):isSelect2?ThemeColor.primaryColor():Colors.black.withOpacity(0.3),
                value: index==1?isSelect1:isSelect2,
                onToggle: (val)=>onClick(),
              ),
            ],
          )],

        ),
      ),
    );
  }


  Widget _BuildEditText({String head, String hint,TextEditingController controller}) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              head,
              style: FunctionHelper.FontTheme(fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withOpacity(0.5))),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: controller,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                  hintText: hint,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _BuildButton() {
    return Container(
      padding: EdgeInsets.only(left: 40,right: 40),
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
          width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: _BuildButtonItem(btnTxt: "บันทึก")));
  }

  Widget _BuildButtonItem({String btnTxt}) {
    return FlatButton(
      color: weightProductController.text.isNotEmpty && widthProductController.text.isNotEmpty&&longProductController.text.isNotEmpty&&heightProductController.text.isNotEmpty?ThemeColor.secondaryColor():Colors.grey.shade400,
      textColor: Colors.white,
      splashColor: Colors.white.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      onPressed: () {},
      child: Text(
        btnTxt,
        style: FunctionHelper.FontTheme(fontSize: 20,fontWeight: FontWeight.w500),
      ),
    );
  }
}

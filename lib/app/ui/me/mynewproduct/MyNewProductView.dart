import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomDropdownList.dart';

class MyNewProductView extends StatefulWidget {
  @override
  _MyNewProductViewState createState() => _MyNewProductViewState();
}

class _MyNewProductViewState extends State<MyNewProductView> {
  TextEditingController nameProductController = TextEditingController();
  TextEditingController detailtController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool checkKeyBoard = false;
  List<String> listUnit = ["ชิ้น","ถุง"];
  List<String> listProvince = ["เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง","ลำพูน","เชียงใหม่","ลำปาง"];
  List<String> listType = ["ผัก","พืช","ข้าว","เนื้อ"];
  List<String> listAddrDeli = ["ทั่วประเทศ","นอกประเทศ","ในประเทศ"];
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
                    Title: "ข้อมูลสินค้า",
                    icon: "",
                    header_type: Header_Type.barNormal,
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildEditText(
                                head: "ชื่อสินค้า * ",
                                hint: "กรอกชื่อสินค้า",maxLength: 10,controller: nameProductController,inputType: TextInputType.text),
                            SizedBox(height: 15,),
                            _BuildDropdown(
                                head: "หมวดหมู่สินค้า *",
                                hint: "เลือกหมวดหมู่",dataList: listType),
                            SizedBox(height: 15,),
                            BuildEditText(
                                head: "รายละเอียดสินค้า * ",maxLength: 5000,
                                hint: "กรอกรายละเอียดสินค้า",maxLine: 5,controller: detailtController,inputType: TextInputType.text),
                            SizedBox(height: 15,),
                            _BuildDropdown(
                                head: "สถานที่จัดส่ง *", hint: "ทั่วประเทศ",dataList: listAddrDeli),
                            SizedBox(height: 15,),
                            _BuildDropdown(
                                head: "ส่งจาก", hint: "เลือกจังหวัด",dataList: listProvince),
                            SizedBox(height: 15,),
                            BuildEditText(
                                head: "ราคาสินค้า * (บาท)", hint: "0",inputType: TextInputType.number,controller: priceController),
                            SizedBox(height: 15,),
                            BuildEditText(head: "จำนวนสินค้า *", hint: "0",inputType: TextInputType.number,controller: amountController),
                            SizedBox(height: 15,),
                            _BuildDropdown(head: "หน่วยสินค้า *", hint: "ชิ้น",dataList: listUnit),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                      _BuildDeliveryTab()
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


  Widget _BuildDropdown({String head, String hint, List<String> dataList}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            head,
            style: GoogleFonts.sarabun(fontSize: 16),
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
  Widget _BuildDeliveryTab() {
    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 10,right: 10),
          margin: EdgeInsets.only(top: 10),
          height: 50,
          child: Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ค่าขนส่ง", style: GoogleFonts.sarabun(fontSize: 16)),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.7),
                  )
                ],
              ))),
      onTap: (){
        AppRoute.DeliveryCost(context);
      },
    );
  }

  Widget _BuildButton() {
    return Container(
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _BuildButtonItem(btnTxt: "บันทึก"),
                ),
                SizedBox(width: 10,)
                ,
                Expanded(child: _BuildButtonItem(btnTxt: "ลงขาย"),)
              ],
            )));
  }

  Widget _BuildButtonItem({String btnTxt}) {
    return FlatButton(
        color: nameProductController.text.length!=0&&detailtController.text.length!=0&&priceController.text.length!=0&&amountController.text.length!=0
            ?ThemeColor.secondaryColor():Colors.grey.shade400,
        textColor: Colors.white,
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          AppRoute.ImageProduct(context);
        },
        child: Text(
          btnTxt,
          style: GoogleFonts.sarabun(fontSize: 20,fontWeight: FontWeight.w500),
        ),
      );

  }
}

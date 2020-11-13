import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
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
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _BuildEditText(
                                head: "ชื่อสินค้า * ",
                                hint: "กรอกชื่อสินค้า",maxLength: 10,controller: nameProductController,inputType: TextInputType.text),
                            _BuildDropdown(
                                head: "หมวดหมู่สินค้า *",
                                hint: "เลือกหมวดหมู่",dataList: listType),
                            _BuildEditText(
                                head: "รายละเอียดสินค้า * ",maxLength: 5000,
                                hint: "กรอกรายละเอียดสินค้า",maxLine: 5,controller: detailtController,inputType: TextInputType.text),
                            _BuildDropdown(
                                head: "สถานที่จัดส่ง *", hint: "ทั่วประเทศ",dataList: listAddrDeli),
                            _BuildDropdown(
                                head: "ส่งจาก", hint: "เลือกจังหวัด",dataList: listProvince),
                            _BuildEditText(
                                head: "ราคาสินค้า * (บาท)", hint: "0",inputType: TextInputType.number,controller: priceController),
                            _BuildEditText(head: "จำนวนสินค้า *", hint: "0",inputType: TextInputType.number,controller: amountController),
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

  Widget _BuildEditText({String head, String hint,int maxLength, TextEditingController controller = null,
    int maxLine=1,TextInputType inputType}) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                head,
                style: GoogleFonts.sarabun(fontSize: 16),
              ),
              inputType==TextInputType.text?Text("(${controller!=null?controller.text.length:0}/${maxLength})"):
              Text("")
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: controller!=null && inputType == TextInputType.text ?controller.text.length<maxLength?Colors.black.withOpacity(0.5):Colors.redAccent:Colors.black.withOpacity(0.5))),
            child: TextFormField(

            keyboardType: inputType,
              maxLines: maxLine,
              controller: controller,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                hintText: hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
              ),
              onChanged: (String char){
               setState(() {

               });
              },
              validator: (value) {
                if (value.isEmpty) {
                    print("-------");
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _BuildDropdown({String head, String hint, List<String> dataList}) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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

  Widget _BuildButton() {
    return Container(
        color: Colors.grey.shade300,
        height: 80,
        child: Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BuildButtonItem(btnTxt: "บันทึก"),
                _BuildButtonItem(btnTxt: "ลงขาย")
              ],
            )));
  }

  Widget _BuildDeliveryTab() {
    return InkWell(
      child: Container(
          color: Colors.white,
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

  Widget _BuildButtonItem({String btnTxt}) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: nameProductController.text.length!=0&&detailtController.text.length!=0&&priceController.text.length!=0&&amountController.text.length!=0
              ?ThemeColor.secondaryColor():Colors.grey.shade400),
      child: Center(
          child: Text(
        btnTxt,
        style: GoogleFonts.sarabun(fontSize: 20, color: Colors.white),
      )),
    );
  }
}

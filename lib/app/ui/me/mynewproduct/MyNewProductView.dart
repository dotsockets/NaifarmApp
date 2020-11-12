import 'package:custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class MyNewProductView extends StatefulWidget {
  @override
  _MyNewProductViewState createState() => _MyNewProductViewState();
}

class _MyNewProductViewState extends State<MyNewProductView> {

  int _dropValue;

  @override
  void initState() {
    super.initState();
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
                  height: 80,
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
                                head: "ชื่อสินค้า * (0/120)",
                                hint: "กรอกชื่อสินค้า"),
                            _BuildDropdown(
                                head: "หมวดหมู่สินค้า *",
                                hint: "เลือกหมวดหมู่"),
                            _BuildDetailEditText(
                                head: "รายละเอียดสินค้า * (0/5000)",
                                hint: "กรอกรายละเอียดสินค้า"),
                            _BuildDropdown(
                                head: "สถานที่จัดส่ง *", hint: "ทั่วประเทศ"),
                            _BuildDropdown(
                                head: "ส่งจาก", hint: "เลือกจังหวัด"),
                            _BuildEditText(
                                head: "ราคาสินค้า * (บาท)", hint: "0"),
                            _BuildEditText(head: "จำนวนสินค้า *", hint: "0"),
                            _BuildEditText(head: "จำนวนสินค้า *", hint: "0"),
                            _BuildDropdown(head: "หน่วยสินค้า *", hint: "ชิ้น"),
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
              _BuildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildEditText({String head, String hint}) {
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
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black.withOpacity(0.5))),
            child: TextField(
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
    );
  }

  Widget _BuildDetailEditText({String head, String hint}) {
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
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black.withOpacity(0.5))),
            child: TextField(
              maxLines: 5,
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
    );
  }

  Widget _BuildDropdown({String head, String hint}) {
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
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black.withOpacity(0.3))),
            child: SingleChildScrollView(
              child: CustomDropdown(
                valueIndex: _dropValue,
                hint: hint,
                borderRadius: 10,
                enabledIconColor: Colors.black.withOpacity(0.5),
                items: [
                  CustomDropdownItem(text: "first"),
                  CustomDropdownItem(text: "second"),
                  CustomDropdownItem(text: "third"),
                  CustomDropdownItem(text: "fourth"),


                ],
                onChanged: (newValue) {
                  setState(()
                  => _dropValue = newValue);
                },
              ),
            ),
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
          borderRadius: BorderRadius.circular(20), color: Colors.grey.shade400),
      child: Center(
          child: Text(
        btnTxt,
        style: GoogleFonts.sarabun(fontSize: 20, color: Colors.white),
      )),
    );
  }
}

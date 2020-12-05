import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class ProductSetPriceView extends StatefulWidget {
  @override
  _ProductSetPriceViewState createState() => _ProductSetPriceViewState();
}

class _ProductSetPriceViewState extends State<ProductSetPriceView> {
  List<String> listColorsType = ["ขาว", "ดำ"];
  List<String> listSizeType = ["S", "M"];
  bool checkEdit0 = false;
  bool checkEdit1 = false;
  TextEditingController txtController = TextEditingController();

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
            title: "ตั้งค่าสต็อกและราคา",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(children: [
                _BuildTitle(),
                Column(
                  children: List.generate(listColorsType.length,
                      (index) => _BuildCard(titleType: listColorsType[index])),
                ),
                _BuildButton(context)
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildCard({String titleType}) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  titleType,
                  style: FunctionHelper.FontTheme(
                      fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
                )),
            Column(
                children: List.generate(
                    listSizeType.length,
                    (index) => Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: FDottedLine(
                                  color: Colors.grey.shade300,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(listSizeType[index],
                                        style: FunctionHelper.FontTheme(
                                            fontSize: SizeUtil.titleFontSize(),
                                            fontWeight: FontWeight.w500)),
                                    Container(
                                      padding: EdgeInsets.only(top: 5,bottom: 5),
                                      width:
                                          MediaQuery.of(context).size.width / 2+5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.4)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TextFormField(
                                              style: FunctionHelper.FontTheme(
                                                  color: Colors.black,
                                                  fontSize: SizeUtil.detailFontSize()),
                                              maxLines: 1,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(5),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                hintText: "฿0",
                                                hintStyle:
                                                    FunctionHelper.FontTheme(
                                                        color: Colors.grey,
                                                        fontSize: SizeUtil.detailFontSize()),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.4)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: TextFormField(
                                                  style: FunctionHelper.FontTheme(
                                                      color: Colors.black,
                                                      fontSize: SizeUtil.detailFontSize()),
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.all(5),
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    hintStyle:
                                                        FunctionHelper.FontTheme(
                                                            color: Colors.grey,
                                                            fontSize: SizeUtil.detailFontSize()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )))
          ],
        ));
  }

  Widget _BuildTitle() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ตัวเลือกสินค้า",
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
          ),
          Text(
            "ราคา",
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
          ),
          Text(
            "จำนวนสินค้า",
            style: FunctionHelper.FontTheme(
                fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget _BuildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: FlatButton(
        color: Colors.grey,
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {},
        child: Text(
          "บันทึก",
          style: FunctionHelper.FontTheme(
              fontSize: SizeUtil.titleFontSize(), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

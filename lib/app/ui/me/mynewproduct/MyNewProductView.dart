import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class MyNewProductView extends StatefulWidget {
  @override
  _MyNewProductViewState createState() => _MyNewProductViewState();
}

class _MyNewProductViewState extends State<MyNewProductView> {
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
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  height: 80,
                  child: AppToobar(Title: "ข้อมูลสินค้า",
                    icon: "",
                    header_type: Header_Type.barNormal,)),
              Column(
                children: [
                  _BuildEditText(head: "ชื่อสินค้า * (0/120)",hint: ""),
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }

  Widget _BuildEditText({String head,String hint}) {
    return Container(
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'กรอกชื่อสินค้า'
        ),
      ),
    );
  }
}

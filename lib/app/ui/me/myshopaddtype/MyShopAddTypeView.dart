import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class MyShopAddTypeView extends StatefulWidget {
  @override
  _MyShopAddTypeViewState createState() => _MyShopAddTypeViewState();
}

class _MyShopAddTypeViewState extends State<MyShopAddTypeView> {
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
          appBar: AppToobar(
            title: "เพิ่มตัวเลือกสินค้า",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [

              ],
            ),
          ),
        ),
      ),
    );
  }
}

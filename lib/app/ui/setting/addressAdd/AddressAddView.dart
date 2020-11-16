import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class AddressAddView extends StatefulWidget {
  @override
  _AddressAddViewState createState() => _AddressAddViewState();
}

class _AddressAddViewState extends State<AddressAddView> {
  TextEditingController nameController = TextEditingController();

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
            Title: "เพิ่มที่อยู่",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            color: Colors.white,
            child: Column(
                children: [
                  BuildEditText(
                      head: "ชื่อ-นามสกุล",
                      hint: "ระบุชื่อ-นามสกุล",maxLength: 10,controller: nameController,inputType: TextInputType.text),
                ],
            ),
          ),
        ),
      ),
    );
  }


}

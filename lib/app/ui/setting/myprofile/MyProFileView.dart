import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
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
            Title: "ข้อมูลส่วนตัว",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';

class HelpView extends StatefulWidget {
  @override
  _HelpViewState createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {

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
            title: "ศูนย์ความช่วยเหลือ",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
                _buildLine(),
                ListMenuItem(icon: '',title: 'xxxxxxxxxxxxxxxxxxx'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildLine(){
    return Container(
      height: 0.5,
      color: Colors.black.withOpacity(0.4),
    );
  }


}

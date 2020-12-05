import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';

class AddressView extends StatefulWidget {
  @override
  _AddressViewState createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
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
            title: "ที่อยู่ของฉัน",
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(
              children: [_buildCardAddr(nameTxt: "วีระชัย ใจกว้าง",typeAddr: "เป็นที่อยู่หลัก"),
                SizedBox(height: 10,),
                _buildCardAddr(nameTxt: "วีระชัย ใจกว้าง",typeAddr: ""),_BuildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardAddr({String nameTxt,String typeAddr}) {
    return Container(
      color: Colors.white,
      
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(nameTxt,style: FunctionHelper.FontTheme(fontSize: 18,color: ThemeColor.primaryColor())),
              Row(
                children: [
                  Text(typeAddr,style: FunctionHelper.FontTheme(fontSize: 18,color: ThemeColor.ColorSale())),
                  Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,)
                ],
              ),
            ],
          ),SizedBox(height: 10,),
            Text("(+66) 978765432",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize())),
            Text("612/399 A space condo ชั้น 4 เขตดินแดง \nจังหวัดกรุงเทพมหานคร\n10400",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize()))
          ],
        ),
      ),
    );
  }
  Widget _BuildButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: FlatButton(
        color: ThemeColor.ColorSale(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100,right: 100,top: 20,bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () {
          AppRoute.SettingAddAddress(context);
        },
        child: Text(
          "เพิ่มที่อยู่ใหม่",
          style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
        ),

      ),
    );
  }
}

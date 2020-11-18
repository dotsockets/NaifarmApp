
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/User.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class Setting_EditProdile_BioView extends StatefulWidget {
  @override
  _Setting_EditProdile_BioViewState createState() => _Setting_EditProdile_BioViewState();
}

class _Setting_EditProdile_BioViewState extends State<Setting_EditProdile_BioView> {
  TextEditingController _input1 = new TextEditingController();

  String onError1 = "";


  bool FormCheck(){
    if(_input1.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _input1.text = "เป็นร้านจำหน่าย";
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppToobar(Title: "แนะนำตัวเอง",header_type: Header_Type.barNormal,),
      body: Container(
        child: Container(
          child: Column(
            children: [
              _Form(),
              SizedBox(height: 30,),
              FlatButton(
                minWidth: 250,
                height: 50,
                color: FormCheck()?ThemeColor.secondaryColor():Colors.grey.shade400,
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: ()=>FormCheck()?verify():SizedBox(),
                child: Text("บันทึก",
                  style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _Form(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20,bottom: 30,left: 20,right: 20),
      child: Column(
        children: [
          BuildEditText(head: "แนะนำตัวเอง",hint: "ระบุข้อความ",inputType: TextInputType.text,maxLine: 5,BorderOpacity: 0.2,maxLength: 20,borderRadius: 5,onError: onError1,controller: _input1,onChanged: (String char){
            setState(() {});
          },),

        ],
      ),
    );
  }

  void verify(){
    // FunctionHelper.showDialogProcess(context);
    // Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
    //     imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
    //   Navigator.of(context).pop();
      // _navigateToProfilePage(context);
     // AppRoute.Home(context);

   // });

  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class Register_FBView extends StatefulWidget {
  final String email;

  const Register_FBView({Key key, this.email}) : super(key: key);
  @override
  _Register_FBViewState createState() => _Register_FBViewState();
}

class _Register_FBViewState extends State<Register_FBView> {
  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();

  bool SuccessForm = false;
  String onError1 = "";
  String onError2 = "";


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _input2.text = widget.email;
  }




  bool FormCheck(){
    if(_input1.text.isEmpty || _input2.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  void verify(){
    bool t1=true,t2=true;
    if(_input1.text.length<=8 || _input1.text.length>=12){
      t1 = false;
      setState(() {
        onError1  = "ควรตั้งรหัสผ่าน 8-12 ตัวอักษรขึ้นไป";
      });
    }

    if(_input2.text.length<=8 || _input2.text.length>=12){
      t2 = false;
      setState(() {
        onError2  = "ควรตั้งรหัสผ่าน 8-12 ตัวอักษรขึ้นไป";
      });
    }else{
      if(_input1.text != _input2.text){
        t2 = false;
        setState(() {
          onError2  = "รหัสผ่านไม่ตรงกัน";
        });
      }
    }



    if(t1){
      setState(() {
        onError1 = "";
      });
    }

    if(t2){
      setState(() {
        onError2 = "";
      });
    }

    if(t1 && t2){
     // AppRoute.Register_Name_Otp(context);
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppToobar(title: "กำหนดรหัสผ่าน",header_type: Header_Type.barNormal,),
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
                child: Text("ถัดไป",
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
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
          BuildEditText(head: "ชื่อผู้เช้าใข้",hint: "ระบุรหัสผ่านใหม่",inputType: TextInputType.text,maxLength: 20,IsPassword: true,borderRadius: 5,controller: _input1,onError: onError1,onChanged: (String char){
            setState(() {});
          },),
          SizedBox(height: 20,),
          BuildEditText(head: "อีเมล",hint: "puwee@gmail.com",inputType: TextInputType.text,maxLength: 50,IsPassword: false,borderRadius: 5,controller: _input2,onError: onError2,onChanged: (String char){
            setState(() {});
          },)
        ],
      ),
    );
  }
}

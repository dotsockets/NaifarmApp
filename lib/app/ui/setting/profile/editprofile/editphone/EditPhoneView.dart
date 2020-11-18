import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class EditPhoneView extends StatefulWidget {
  @override
  _EditPhoneViewState createState() => _EditPhoneViewState();
}

class _EditPhoneViewState extends State<EditPhoneView> {
  TextEditingController PhoneController = TextEditingController();

  bool FormCheck(){
    if(PhoneController.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneController.text = "0941654641";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        Title: "เบอร์โทรศัพท์", header_type: Header_Type.barNormal,),
      body: Column(
        children: [
          Container(padding:EdgeInsets.all(15), child: Text("หากคุณแก้ไขหมายเลขโทรศัพท์ที่นี่  หมายเลขบัญชีทั้งหมดที่ผู้กับบัญชีนี้จะถูกแก้ไขด้วย",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(40)),),),
          Container(
            color: Colors.white,
            child: Container(
              padding:EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("หมายเลขโทรศัพท์เดิม xxxxxx0987 ",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(50))),
                  SizedBox(height: 20,),
                  BuildEditText(
                      head: "กรุณาใส่หมายเลขใหม่เพื่อรับ OTP",
                      hint: "หมายเลขโทรศัพท์ใหม่",maxLength: 10,controller: PhoneController,inputType: TextInputType.phone,BorderOpacity: 0.2,onChanged: (String char){
                    setState(() {});
                    }),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          FlatButton(
            minWidth: 250,
            height: 50,
            color: FormCheck()?ThemeColor.ColorSale():Colors.grey.shade400,
            textColor: Colors.white,
            splashColor: Colors.white.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            onPressed: ()=>FormCheck()?verify():SizedBox(),
            child: Text("ดำเนินการต่อ",
              style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
            ),
          )
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

    //});

  }
}

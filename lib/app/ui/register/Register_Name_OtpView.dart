
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/User.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';


class Register_Name_OtpView extends StatefulWidget {
  final String phone;
  final String password;

  const Register_Name_OtpView({Key key, this.phone, this.password}) : super(key: key);
  @override
  _Register_Name_OtpViewState createState() => _Register_Name_OtpViewState();
}

class _Register_Name_OtpViewState extends State<Register_Name_OtpView> {

  TextEditingController _input1 = new TextEditingController();
  TextEditingController _input2 = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String onError1 = "";
  String onError2 = "";
  MemberBloc bloc;


  bool FormCheck(){
    if(_input1.text.isEmpty && _input2.text.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  void _init(){
    if(null == bloc){
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        AppRoute.Home(context);
      });
    }

  }




  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppToobar(title: "ชื่อผู้เช้าใข้",header_type: Header_Type.barNormal,),
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
                onPressed: ()=>verify(),
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
          BuildEditText(head: "ชื่อผู้เช้าใข้",hint: "ระบุชื่อผู้เช้าใข้",inputType: TextInputType.text,maxLength: 20,borderRadius: 5,onError: onError1,controller: _input1,onChanged: (String char){
            setState(() {});
          },),
          SizedBox(height: 20,),
          BuildEditText(head: "อีเมล",hint: "ระบุอีเมล",inputType: TextInputType.emailAddress,maxLength: 20,borderRadius: 5,onError: onError2,controller: _input2,onChanged: (String char){
            setState(() {});
          },)
        ],
      ),
    );
  }

  void verify(){
  //  FunctionHelper.showDialogProcess(context);

    if(_input1.text.isEmpty || _input1.text.length<6){
      setState(()=> onError1 = "ชื่อผู้ใช้งานต้องต้องมีตัวหนังสือ 6 ขึ้นไป");
    }else{
      setState(()=> onError1 = "");
    }
    if(!validator.email(_input2.text)){
      setState(()=> onError2 = "รูปแบบอีเมล์ไม่ถูกต้อง");
    }
    else{
      setState(()=> onError2 = "");
    }

    if(onError1=="" && onError2==""){
      bloc.CustomersRegister(registerRequest: RegisterRequest(name: _input1.text,email: _input2.text,
          password: widget.password,phone: widget.phone,agree: 0));
    }



    // Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
    //     imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
    //   Navigator.of(context).pop();
    //   // _navigateToProfilePage(context);
    //   AppRoute.Home(context);
    //
    // });

  }
}

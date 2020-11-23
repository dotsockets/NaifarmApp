import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class EditPhone_Step2View extends StatefulWidget {
  final String PhoneNew;

  const EditPhone_Step2View({Key key, this.PhoneNew}) : super(key: key);

  @override
  _EditPhone_Step2ViewState createState() => _EditPhone_Step2ViewState();
}

class _EditPhone_Step2ViewState extends State<EditPhone_Step2View> {
  TextEditingController PhoneController = TextEditingController();
  TextEditingController OtpController = TextEditingController();
  String onErrorOtp="";

  bool FormCheck() {
    if (OtpController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneController.text = widget.PhoneNew;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        Title: "เบอร์โทรศัพท์",
        header_type: Header_Type.barNormal,
        onClick: () {
          FunctionHelper.ConfirmDialog(context,
              message: "คุณต้องการออกจากการเปลี่ยนแปลงเบอร์โทรศัพท์ใช่หรือไม่",
              onClick: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }, onCancel: () {
            Navigator.of(context).pop();
          });
        },
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Text(
              "หากคุณแก้ไขหมายเลขโทรศัพท์ที่นี่  หมายเลขบัญชีทั้งหมดที่ผู้กับบัญชีนี้จะถูกแก้ไขด้วย",
              style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(40)),
            ),
          ),
          Container(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("หมายเลขโทรศัพท์เดิม xxxxxx0987 ",
                      style: GoogleFonts.sarabun(
                          fontSize: ScreenUtil().setSp(50))),
                  SizedBox(
                    height: 20,
                  ),
                  BuildEditText(
                      head: "กรุณาใส่หมายเลขใหม่เพื่อรับ OTP",
                      hint: "หมายเลขโทรศัพท์ใหม่",
                      maxLength: 10,
                      controller: PhoneController,
                      inputType: TextInputType.phone,
                      readOnly: true,
                      BorderOpacity: 0.2,
                      onChanged: (String char) {
                        setState(() {});
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  BuildEditText(
                      head: "ยืนยัน OTP [Ref : tedf]",
                      hint: "กรอก OTP",
                      maxLength: 6,
                      controller: OtpController,
                      inputType: TextInputType.phone,
                      BorderOpacity: 0.2,
                      onError: onErrorOtp,
                      onChanged: (String char) {
                        setState(() {});
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: InkWell(
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/svg/change.svg'),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "ขอรหัสยืนยันใหม่อีกครั้ง",
                            style: GoogleFonts.sarabun(
                                fontSize: ScreenUtil().setSp(38)),
                          )
                        ],
                      ),
                      onTap: () {
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            minWidth: 250,
            height: 50,
            color: FormCheck() ? ThemeColor.ColorSale() : Colors.grey.shade400,
            textColor: Colors.white,
            splashColor: Colors.white.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            onPressed: () => FormCheck() ? verify() : SizedBox(),
            child: Text(
              FormCheck() ? "ยืนยัน" : "ดำเนินการต่อ",
              style: GoogleFonts.sarabun(
                  fontSize: ScreenUtil().setSp(45),
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  void verify() {
    if (OtpController.text.length < 6) {
        setState(()=>onErrorOtp = "รหัสยืนยันต้องไม่น้อยกว่า 6");
    }else{
        FunctionHelper.SuccessDialog(context,message: "เปลี่ยนเบอร์โทรศัพท์สำเร็จ",onClick: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
    }
  }
}

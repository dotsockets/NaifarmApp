

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class EditEmail_Step3View extends StatefulWidget {
  final String email;

  const EditEmail_Step3View({Key key, this.email}) : super(key: key);
  @override
  _EditEmail_Step3ViewState createState() => _EditEmail_Step3ViewState();
}

class _EditEmail_Step3ViewState extends State<EditEmail_Step3View> {
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
    PhoneController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        Title: "อีเมลใหม่",
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
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  BuildEditText(
                      head: "อีเมลใหม่ OTP",
                      hint: "ระบุอีเมลใหม่",
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
                  Text("กรุณาเปิดอีเมล ${widget.email} เพื่อรับ OTP"),
                  SizedBox(
                    height: 5,
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
      FunctionHelper.SuccessDialog(context,message: "เปลี่ยนอีเมลสำเร็จ",onClick: (){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  }
}

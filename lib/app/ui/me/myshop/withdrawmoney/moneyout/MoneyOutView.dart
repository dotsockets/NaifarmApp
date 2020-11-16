import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';

class MoneyOutView extends StatefulWidget {
  @override
  _MoneyOutViewState createState() => _MoneyOutViewState();
}

class _MoneyOutViewState extends State<MoneyOutView> {
  TextEditingController inputController = TextEditingController();
  bool CheckBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppToobar(
        Title: "ถอนเงิน",
        header_type: Header_Type.barNormal,
        icon: "",
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _BuildContent(),
              ),
              _BuildButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildContent() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildCardBank(),
            SizedBox(
              height: 10,
            ),
            _BuildForm()
          ],
        ),
      ),
    );
  }

  Widget _BuildCardBank() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("การถอนเงิน Wallet ไปที่",style: GoogleFonts.sarabun(fontSize: 18),),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    height: 30,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child:
                          Lottie.asset(Env.value.loadingAnimaion, height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://img.utdstc.com/icons/scb-easy-android.png:225",
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("ธนาคารไทยพาณิช",style: GoogleFonts.sarabun(fontSize: 16)),
                ],
              ),
              Row(
                children: [
                  Text("* 9803",style: GoogleFonts.sarabun(fontSize: 16)),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade500,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _BuildForm() {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(child: SvgPicture.asset(CheckBox?'assets/images/svg/Check_CheckBox.svg':'assets/images/svg/Uncheck_CheckBox.svg',width: 20,height: 20,),onTap: (){
                setState(() {
                  CheckBox = CheckBox?false:true;
                });
              },),
              SizedBox(width: 10,),
              Text("ถอนเงินทั้งหมดใน Wallet (฿300.00)",style: GoogleFonts.sarabun(fontSize: 16))
            ],
          ),
          SizedBox(height: 10,),
          Text("ยอดที่ต้องการถอน (บาท)",style: GoogleFonts.sarabun(fontSize: 16)),
          BuildEditText(
              head: "",maxLength: 16,
              hint: "0.00",maxLine: 1,controller: inputController,inputType: TextInputType.number),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ค่าธรรมเนียนการถอนเงิน",style: GoogleFonts.sarabun(fontSize: 16)),
              Text("ฟรี",style: GoogleFonts.sarabun(fontSize: 16))
            ],
          )
        ],
      ),
    );
  }

  Widget _BuildButton(BuildContext context) {
    return Container(
      child: FlatButton(
        minWidth: MediaQuery.of(context).size.width,
        color: ThemeColor.secondaryColor(),
        textColor: Colors.white,
        padding: EdgeInsets.only(left: 100, right: 100, top: 20, bottom: 20),
        splashColor: Colors.white.withOpacity(0.3),
        onPressed: () {
          /*...*/
        },
        child: Text(
          "ยืนยัน",
          style: GoogleFonts.sarabun(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

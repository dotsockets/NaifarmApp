
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';

class OrderView extends StatelessWidget {
  int  Status_Sell;
  OrderView({Key key,this.Status_Sell}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: ThemeColor.primaryColor(),
          title: Text(
            "รายละเอียดคำสั่งซื้อ",
            style: GoogleFonts.sarabun(color: Colors.black),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderStatus(context: context),
                    _labelText(title: "ที่อยู่ในการส่ง"),
                    _addtess_recive(context: context),
                    _labelText(title: "ข้อมูลการจัดส่ง"),
                    _Shipping_information(context: context),
                    SizedBox(height: 15,),
                    _Order_number_information(context: context),
                    _labelText(title: "ช่องทางการชำระเงิน"),
                    _payment_info(context: context),
                    SizedBox(height: 15,),
                    _Timeline_order(context: context)
                  ],
                ),
              ),
            ),
            _ButtonAgain(context: context),
          ],
        ),
      ),
    );
  }

  Widget _HeaderStatusText(){
      return Container(
        width: 320,
        height: 60,
        margin: EdgeInsets.only(top: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: EdgeInsets.only(right: 13,left: 10,top: 5,bottom: 5),
            color: ThemeColor.primaryColor(),
            child: Center(child: Text(Status_Sell==3?"รอให้คะแนน":Status_Sell==4?"ให้คะแนนแล้ว ":"ยกเลิกแล้ว",style: GoogleFonts.sarabun(fontSize: 20,color: Colors.white),)),
          ),
        ),
      );
  }

  Widget _HeaderStatus({BuildContext context}){
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft: Radius.circular(40)),
              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text("คำสั่งซื้อเสร็จสมบูรณ์และขอบคุณสำหรับการให้คะแนน",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                SizedBox(height: 3),
                Text("เวลาที่สำเร็จ 28-06-2563  18:39",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black.withOpacity(0.5)),)
              ]
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _HeaderStatusText(),
        )
      ],
    );
  }
  
  Widget _labelText({String title}){
    return Container(
      padding: EdgeInsets.only(left: 15,top: 15,bottom: 15),
      child: Text(title,style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
    );
  }

  Widget _addtess_recive({BuildContext context}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("วีระชัย ใจกว้าง",style: GoogleFonts.sarabun(fontSize: 18,color: ThemeColor.primaryColor(),fontWeight: FontWeight.bold,height: 1.5),),
            SizedBox(height: 8),
            Text("(+66) 978765432",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
            Text("612/399 A space condo ชั้น 4 เขตดินแดง",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
            Text("จังหวัดกรุงเทพมหานคร ",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
            Text("10400 ",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
          ],
        ),
    );
  }


  Widget _Shipping_information({BuildContext context}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("วีระชัย ใจกว้าง",style: GoogleFonts.sarabun(fontSize: 18,color: ThemeColor.primaryColor(),fontWeight: FontWeight.bold,height: 1.5),),
          SizedBox(height: 8),
          Text("(+66) 978765432",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
          Text("612/399 A space condo ชั้น 4 เขตดินแดง",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
          Text("จังหวัดกรุงเทพมหานคร ",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
          Text("10400 ",style: GoogleFonts.sarabun(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,height: 1.5),),
        ],
      ),
    );
  }

  Widget _Order_number_information({BuildContext context}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("หมายเลขคำสั่งซื้อ",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                Text("09988203dergd4",style: GoogleFonts.sarabun(fontSize: 16,color:ThemeColor.ColorSale(),fontWeight: FontWeight.bold,height: 1.5),),
              ],
            ),
            SizedBox(height: 13,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        width: 30,
                        height: 30,
                        placeholder: (context, url) => Container(
                          color: Colors.white,
                          child:
                          Lottie.asset(Env.value.loadingAnimaion, height: 30),
                        ),
                        fit: BoxFit.cover,
                        imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Dwayne_Johnson_at_the_2009_Tribeca_Film_Festival.jpg/220px-Dwayne_Johnson_at_the_2009_Tribeca_Film_Festival.jpg",
                        errorWidget: (context, url, error) => Container(
                            height: 30,
                            child: Icon(
                              Icons.error,
                              size: 30,
                            )),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Text("ไร่มอนหลวงสาย",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),)
                  ],
                ),
                Row(
                  children: [
                    Text("ไปยังร้านค้า",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                    SizedBox(width: 10,),
                    Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,)
                  ],
                ),
              ],
            ),
            SizedBox(height: 13,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: CachedNetworkImage(
                    width: 80,
                    height: 80,
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl: "https://www.img.in.th/images/7fc6ff825238293be21ea341e2f54755.png",
                    errorWidget: (context, url, error) => Container(
                        height: 30,
                        child: Icon(
                          Icons.error,
                          size: 30,
                        )),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("หอมใหญ่",
                          style: GoogleFonts.sarabun(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("x 2",
                              style: GoogleFonts.sarabun(
                                  fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text("฿140",
                                  style: GoogleFonts.sarabun(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,color: Colors.black.withOpacity(0.5))),
                              SizedBox(width: 8),
                              Text("฿100",
                                  style: GoogleFonts.sarabun(
                                      fontSize: 16, color: Colors.black))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 13,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("รวมค่าสินค้า :",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                SizedBox(width: 10,),
                Text("฿100", style: GoogleFonts.sarabun(fontSize: 16, color: Colors.black))
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ค่าจัดส่ง :",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                SizedBox(width: 10,),
                Text("฿36.00", style: GoogleFonts.sarabun(fontSize: 16, color: Colors.black))
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("รวม :",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                SizedBox(width: 10,),
                Text("฿136.00", style: GoogleFonts.sarabun(fontSize: 16, color: ThemeColor.ColorSale()))
              ],
            ),
          ],
        ),
    );
  }


  Widget _payment_info({BuildContext context}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          CachedNetworkImage(
            height: 30,
            placeholder: (context, url) => Container(
              color: Colors.white,
              child:
              Lottie.asset(Env.value.loadingAnimaion, height: 30),
            ),
            fit: BoxFit.cover,
            imageUrl: "https://img.utdstc.com/icons/scb-easy-android.png:225",
            errorWidget: (context, url, error) => Container(
                height: 30,
                child: Icon(
                  Icons.error,
                  size: 30,
                )),
          ),
          SizedBox(width: 10,),
          Text("ธนาคารไทยพาณิชย์", style: GoogleFonts.sarabun(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _Timeline_order({BuildContext context}){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("หมายเลขคำสั่งซื้อ",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
              Text("09988203dergd4",style: GoogleFonts.sarabun(fontSize: 16,color:ThemeColor.ColorSale(),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("เวลาที่สั่งซื้อ",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("28-07-2563  12:49",style: GoogleFonts.sarabun(fontSize: 16,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("เวลาชำระเงิน",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("28-07-2563  12:49",style: GoogleFonts.sarabun(fontSize: 16,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("เวลาส่งสินค้า",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("30-07-2563  12:49",style: GoogleFonts.sarabun(fontSize: 16,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("เวลาที่สำเร็จ",style: GoogleFonts.sarabun(fontSize: 16,color: Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
              Text("31-07-2563  12:49",style: GoogleFonts.sarabun(fontSize: 16,color:Colors.black.withOpacity(0.5),fontWeight: FontWeight.bold,height: 1.5),),
            ],
          ),
          SizedBox(height: 13,),
        ],
      ),
    );
  }

  Widget _ButtonAgain({BuildContext context}){
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.3)))
        ),
        child: Row(
          children: [
            Status_Sell!=5?Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 15,right: 15,bottom: 0),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/svg/status_star.svg',width: 60,height: 60,),
                    SizedBox(width: 0,),
                    Text("ริวิว",style: GoogleFonts.sarabun(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,height: 1.5),),
                  ],
                ),
              ),
            ):SizedBox(),
            Expanded(
              flex: 7,
              child: Container(
                height: 60,
                child: FlatButton(
                  color: ThemeColor.ColorSale(),
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  onPressed: () {
                    /*...*/
                  },
                  child: Text(
                    "ซื้อสินค้าอีกครั้ง",
                    style: GoogleFonts.sarabun(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      );
  }

}

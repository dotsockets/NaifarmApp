import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/AddressModel.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';

class CartAaddressView extends StatefulWidget {
  @override
  _CartAaddressViewState createState() => _CartAaddressViewState();
}

class _CartAaddressViewState extends State<CartAaddressView> {
  List<CartModel> _data_aar = List<CartModel>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int select = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data_aar.addAll(CartViewModel().getMyCart());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            _data_aar.length != 0 ? Colors.grey.shade300 : Colors.white,
        appBar: AppBar(
          backgroundColor: ThemeColor.primaryColor(),
          title: Text(
            "ที่อยู่ของฉัน",
            style: GoogleFonts.sarabun(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
                Column(
                  children: CartViewModel().getAddressCart().asMap().map((index, value){
                        return MapEntry(index, _BuildCard(item: CartViewModel().getAddressCart()[index],index: index));
                  }).values.toList(),
                ),
              SizedBox(height: 30,),
              _buildBtnAddProduct(),
            ],
          ),
        )
      ),
    );
  }

  Widget _BuildCard({AddressModel item,int index}){
    return Container(
      margin: EdgeInsets.only(top: index==0?0:10),
      padding: EdgeInsets.only(top: 10,bottom: 10),
      color: Colors.white,
        child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  child: select==index
                      ? SvgPicture.asset(
                    'assets/images/svg/checkmark.svg',
                    width: 25,
                    height: 25,
                    color: ThemeColor.primaryColor(),
                  )
                      : SvgPicture.asset(
                    'assets/images/svg/uncheckmark.svg',
                    width: 25,
                    height: 25,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onTap: () {
                    setState(() {
                      select = select!=index ? index : 0;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(item.Name,style: GoogleFonts.sarabun(fontWeight: FontWeight.bold,fontSize: 18,height: 1.6,color: ThemeColor.primaryColor()),),
                  Row(
                         children: [
                           select==index?Text("เป็นที่อยู่หลัก",style: GoogleFonts.sarabun(fontWeight: FontWeight.w500,fontSize: 16,color: ThemeColor.ColorSale())):SizedBox(),
                           SizedBox(width: 5,),
                           Icon(Icons.arrow_forward_ios,color: Colors.grey.shade500,)
                         ],
                       ),

                     ],
                   ),
                    SizedBox(height: 5,),
                    Text(item.phone,style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),),
                    Text(item.address,style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),),
                    Text(item.provice,style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),),
                    Text(item.zipcode,style: GoogleFonts.sarabun(fontSize: 14,height: 1.5),),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }

  Widget _buildBtnAddProduct(){
    return Container(

      child: FlatButton(
        color: ThemeColor.secondaryColor(),
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
          style: GoogleFonts.sarabun(fontSize: 16,fontWeight: FontWeight.w500),
        ),
      ),
    );
  }


}

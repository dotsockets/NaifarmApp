import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class MyProductView extends StatefulWidget {
  @override
  _MyProductViewState createState() => _MyProductViewState();
}

class _MyProductViewState extends State<MyProductView> {
  int status = 999;

  List<ProductModel> listProducts = ProductViewModel().getMyProducts();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppToobar(
          Title: "สินค้าของฉัน",
          icon: "",
          header_type: Header_Type.barNormal,
        ),
        body: Container(
          color: Colors.grey.shade300,
          child: Column(

            children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(listProducts.length, (index) =>
                          _BuildProduct(item: listProducts[index],index: index),),
                    ),
                  ),
                ),
              _BuildButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildButton() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: ThemeColor.primaryColor(),
        child: Center(child: Text("เพิ่มสินค้า",style: GoogleFonts.sarabun(fontSize: 20,color: Colors.white),))
      ),
      onTap: (){
        AppRoute.MyNewProduct(context);
      },
    );

  }

  Widget _BuildProduct(
      {ProductModel item,int index}) {
    return Container(
      margin: EdgeInsets.only(bottom: 3),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.contain,
                  width: 140,
                  height: 160,
                  imageUrl: item.product_image,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product_name,
                      style: GoogleFonts.sarabun(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "฿${item.product_price}",
                      style: GoogleFonts.sarabun(
                          fontSize: 18,
                          color: ThemeColor.ColorSale(),
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("จำนวนสินค้า ${item.amoutProduct}",
                              style: GoogleFonts.sarabun(fontSize: 15)),
                          Text(
                            "${item.product_status}",
                            style: GoogleFonts.sarabun(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 200,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ถูกใจ 10", style: GoogleFonts.sarabun(fontSize: 15)),
                            Text("เข้าชม 10", style: GoogleFonts.sarabun(fontSize: 15),
                            )
                          ]),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.isSelect?"ขายสินค้า":"พักการขาย",
                      style: GoogleFonts.sarabun(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    FlutterSwitch(
                      width: 60.0,
                      height: 30.0,
                      toggleSize: 25.0,
                      activeColor: Colors.grey.shade200,
                      inactiveColor: Colors.grey.shade200,
                      toggleColor: item.isSelect?ThemeColor.primaryColor():Colors.grey.shade400,
                      value: item.isSelect?true:false,
                      onToggle: (val) {
                        setState(() {
                           listProducts[index].isSelect = val;
                        });
                      },
                    ),
                    SvgPicture.asset(
                      'assets/images/svg/Edit.svg',
                      width: 25,
                      height: 25,
                      color: ThemeColor.ColorSale(),
                    ),
                    SvgPicture.asset(
                      'assets/images/svg/trash.svg',
                      width: 25,
                      height: 25,
                      color: ThemeColor.ColorSale(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

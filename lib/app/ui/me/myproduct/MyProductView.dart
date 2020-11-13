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
    return Container(
      color: ThemeColor.secondaryColor(),
      child: SafeArea(
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
      ),
    );
  }


  Widget _BuildButton() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        child: FlatButton(
          color: ThemeColor.secondaryColor(),
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          onPressed: () {AppRoute.MyNewProduct(context);},
          child: Text(
            "เพิ่มสินค้า",
            style: GoogleFonts.sarabun(fontSize: 20,fontWeight: FontWeight.w500),
          ),
        ),
      );
  }

  Widget _BuildProduct(
      {ProductModel item,int index}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10,right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product_name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.sarabun(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "฿${item.product_price}",
                          style: GoogleFonts.sarabun(
                              fontSize: 22,
                              color: ThemeColor.ColorSale(),
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("จำนวนสินค้า ${item.amoutProduct}",
                                    style: GoogleFonts.sarabun(fontSize: 14)),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "${item.product_status}",
                                    style: GoogleFonts.sarabun(fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text("ถูกใจ 10", style: GoogleFonts.sarabun(fontSize: 15)),),
                                SizedBox(width: 10,),
                                Expanded(child: Align(alignment: Alignment.topRight,child: Text("เข้าชม 10", style: GoogleFonts.sarabun(fontSize: 15),))
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                   Expanded(
                     flex: 2,
                     child:  Text(
                       item.isSelect?"ขายสินค้า":"พักการขาย",
                       style: GoogleFonts.sarabun(
                           fontSize: 18, fontWeight: FontWeight.w600),
                     ),
                   ),
                    Container(height: 50,color: Colors.grey.shade300,),
                    Expanded(
                      flex: 1,
                      child: FlutterSwitch(
                        height: 35,
                        toggleSize: 30,
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
                    ),
                    SizedBox(width: 20,),
                    Container(width: 1,height: 50,color: Colors.grey.shade300,),
                    Expanded(
                       child: Container(
                         child: SvgPicture.asset(
                           'assets/images/svg/Edit.svg',
                           width: 25,
                           height: 25,
                           color: ThemeColor.ColorSale(),
                         ),
                       ),
                    ),
                    Container(width: 1,height: 50,color: Colors.grey.shade300,),
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/images/svg/trash.svg',
                        width: 25,
                        height: 25,
                        color: ThemeColor.ColorSale(),
                      ),
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

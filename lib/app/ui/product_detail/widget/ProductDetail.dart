import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/utility/widgets/ExpandableText.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel productDetail;

  const ProductDetail({Key key, this.productDetail}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  GlobalKey _keyRed = GlobalKey();

  int lineInto = 7;
  int IntoLine = 0;

  _getSizes() {
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;

    setState(() {
      IntoLine = (sizeRed / 22).height.toInt();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getSizes());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: Text(
              "รายละเอียดสินค้า",
              style: GoogleFonts.sarabun(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.5),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "จำนวนสินค้า",
                      style: GoogleFonts.sarabun(
                          color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "สถานที่จัดส่ง",
                      style: GoogleFonts.sarabun(
                          color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "ส่งจาก",
                      style: GoogleFonts.sarabun(
                          color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "409 กิโลกรัม",
                      style: GoogleFonts.sarabun(
                          color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "ทั่วประเทศ",
                      style: GoogleFonts.sarabun(
                          color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "อำเภอฝาง, จังหวัดเชียงราย",
                      style: GoogleFonts.sarabun(
                          color: Colors.black, fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.5),
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 8),
                child: Text(
                  widget.productDetail.ProductInto,
                  style: GoogleFonts.sarabun(height: 1.6),
                  maxLines: lineInto,
                  key: _keyRed,
                ),
              ),
              IntoLine > 6
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                                colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.5)
                            ])),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                      ),
                    )
                  : SizedBox(),
              IntoLine > 6
                  ? Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Text(
                              "อ่านเพิ่มเติม",
                              style: GoogleFonts.sarabun(
                                  color: ThemeColor.primaryColor(),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ))),
                        onTap: () {
                          setState(() {
                            lineInto = 100;
                            IntoLine = 0;
                          });
                        },
                      ))
                  : SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}


import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:sizer/sizer.dart';

class FlashSaleView extends StatelessWidget {

  final List<ProductModel> _producViewModel = ProductViewModel().getFlashSaleProduct();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.withOpacity(0.3),
            child: StickyHeader(
              header:  AppToobar(title: "Flash Sale",header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
              content: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft: Radius.circular(40)),
                        border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        ProductGrid(
                          producViewModel: ProductViewModel().getMarketRecommend(),
                          IconInto: 'assets/images/svg/like.svg',
                          onSelectMore: () {

                          },
                          onTapItem: (int index) {
                            AppRoute.ProductDetail(context,
                                productImage: "special_${index}");
                          },EnableHeader: false,tagHero: "special",FlashSallLabel: true,)
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _flashSaleText(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _flashSaleText(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: EdgeInsets.only(right: 13,left: 10,top: 5,bottom: 5),
          color: ThemeColor.ColorSale(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/images/svg/flash_sale.svg',width: 45,height: 45,),
              Text("Fla",style: GoogleFonts.kanit(fontSize: SizeUtil.titleFontSize().sp,color: Colors.white)),
              SizedBox(width: 5),
              SvgPicture.asset('assets/images/svg/flash.svg',width: 45,height: 40,),
              SizedBox(width: 5),
              Text("h Sale",style: GoogleFonts.kanit(fontSize: SizeUtil.titleFontSize().sp,color: Colors.white)),
              SizedBox(width: 10),
              _buildCountDown()
            ],
          ),
        ),
      ),
    );
  }

  CountdownFormatted _buildCountDown() => CountdownFormatted(
    duration: Duration(hours: 1),
    onFinish: null,
    builder: (BuildContext context, String remaining) {
      final showTime = (String text) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.only(left: 9,right: 9,top: 7,bottom: 7),
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            text,
            style: FunctionHelper.FontTheme(
              fontSize: SizeUtil.titleFontSize().sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
      List<String> time = remaining.split(':').toList();
      return Row(
        children: [
          showTime(time[0]),
          showTime(time[1]),
          showTime(time[2]),
        ],
      ); // 01:00:00
    },
  );
}

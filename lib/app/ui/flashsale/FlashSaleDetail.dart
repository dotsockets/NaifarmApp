
import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/FlashSaleBar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:sizer/sizer.dart';

import 'ProductGridFlashSaleView.dart';

class FlashSaleView extends StatefulWidget {
  final FlashsaleRespone instalData;

  FlashSaleView({Key key, this.instalData}) : super(key: key);
  @override
  _FlashSaleViewState createState() => _FlashSaleViewState();
}

class _FlashSaleViewState extends State<FlashSaleView> {


  ProductBloc bloc;
  List<ProductData> product_data = List<ProductData>();


  void _init(){
    if(null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      if(widget.instalData!=null){
        bloc.Flashsale.add(widget.instalData);
      }else{
        bloc.loadFlashsaleData(page: "1",limit: 5);
      }

    }


  }

  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor:  Colors.grey.shade300,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,

            child: StickyHeader(
              header:  AppToobar(title: "Flash Sale",header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
              content: Stack(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular( widget.instalData.data.length !=0?0:40),bottomRight: Radius.circular(widget.instalData.data.length !=0?0:40)
                        ),
                        border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                    ),
                    child:   widget.instalData.data.length ==0?
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height:50.0.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ไม่พบสินค้า",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ) :
                    Column(
                      children: [
                        SizedBox(height: 50),

                        ProductGridFlashSaleView(
                          flashsaleProduct: widget.instalData,
                          producViewModel: ProductViewModel().getMarketRecommend(),
                          IconInto: 'assets/images/svg/like.svg',
                          onSelectMore: () {

                          },
                          onTapItem: (int index) {
                            AppRoute.ProductDetail(context,
                                productImage: "special_${index}",productItem: ProductBloc.ConvertDataToProduct(data: widget.instalData.data[0].items[index].product));
                          },EnableHeader: false,tagHero: "special",FlashSallLabel: true,api_link: "flashsale",)
                        ,
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlashSaleBar(timeFlash:  widget.instalData.data[0].end,),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

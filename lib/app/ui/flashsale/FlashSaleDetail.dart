import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';
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
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/FlashSaleBar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:rxdart/subjects.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers.dart';


class FlashSaleView extends StatefulWidget {
  final FlashsaleRespone instalData;

  FlashSaleView({Key key, this.instalData}) : super(key: key);
  @override
  _FlashSaleViewState createState() => _FlashSaleViewState();
}

class _FlashSaleViewState extends State<FlashSaleView> {


  ProductBloc bloc;
  int page = 1;
  int limit = 10;
  ScrollController _scrollController = ScrollController();
  bool step_page = false;

  final position_scroll = BehaviorSubject<bool>();



  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));

      if (ConvertProductData() != null) {
        bloc.product_more.addAll(ConvertProductData());
      //  bloc.product_more.addAll(ConvertProductData());
        bloc.MoreProduct.add(ProductRespone(
            data: bloc.product_more,
            total: ConvertProductData().length,
            limit: limit.toString()));
      } else {
        bloc.loadMoreData(
            page: page.toString(), limit: limit, link: "flashsale");
      }
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
          _scrollController.position.pixels <=
          200) {
        if (step_page && bloc.product_more.length != widget.instalData.total) {
          step_page = false;
          page++;
          bloc.loadMoreData(
              page: page.toString(),
              limit: limit,
              link: "flashsale");
        }
      }

      if (_scrollController.position.pixels > 500) {
        position_scroll.add(true);
      } else {
        position_scroll.add(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor:  Colors.grey.shade300,
       // appBar: AppToobar(title: "Flash Sale",header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
        body: SingleChildScrollView(
          child: StickyHeader(
            header: AppToobar(title: "Flash Sale",header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
            content: Container(
              margin: EdgeInsets.only(top: 2.0.h),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 6.0.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight:  Radius.circular(50),topLeft: Radius.circular(50),
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
                    content,
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FlashSaleBar(timeFlash:  widget.instalData.data[0].end,),
                  ),
                  StreamBuilder(
                      stream:position_scroll.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data?Container(
                            margin: EdgeInsets.only(right: 5.0.w, bottom:  5.0.w),
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 13.0.w,
                                  height: 13.0.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.4)
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_up_outlined,
                                      size: 8.0.w,
                                      color: Colors.white,
                                    ),
                                    onPressed: (){
                                      _scrollController.animateTo(
                                          _scrollController.position.minScrollExtent,
                                          duration: Duration(milliseconds: 1000),
                                          curve: Curves.ease);
                                    },
                                  ),
                                )
                            ),
                          ):SizedBox();
                        } else {
                          return SizedBox();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget get content =>  Container(
    margin: EdgeInsets.only(top: 4.0.h),
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: bloc.MoreProduct.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          step_page = true;
          if (snapshot.hasData) {
            var item = (snapshot.data as ProductRespone);
            step_page = true;
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              itemBuilder: (context, i) {
                // if ( i+1==((item.data.length) / 2).round()) {
                //   return CupertinoActivityIndicator();
                // }

                return Container(
                  child: Column(
                    children: [
                      item.data.length - (i) * 2 > 1
                          ? Row(
                        children: [
                          Expanded(
                              child: _buildProduct(
                                  item: item.data[(i * 2)],
                                  index: (i * 2),
                                  context: context)),
                          Expanded(
                              child: _buildProduct(
                                  item: item.data[(i * 2) + 1],
                                  index: ((i * 2) + 1),
                                  context: context))
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(
                              child: _buildProduct(
                                  item: item.data[(i * 2)],
                                  index: (i * 2),
                                  context: context)),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      if (item.data.length != item.total)
                        i + 1 == ((item.data.length) / 2).round()
                            ? Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                          Platform.isAndroid
                          ? SizedBox(width: 5.0.w,height: 5.0.w,child: CircularProgressIndicator())
                                : CupertinoActivityIndicator(),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Loading",
                                  style: FunctionHelper.FontTheme(
                                      color: Colors.grey,
                                      fontSize:
                                      SizeUtil.priceFontSize()
                                          .sp))
                            ],
                          ),
                        )
                            : SizedBox()
                    ],
                  ),
                );
              },
              itemCount: ((item.data.length) / 2).round(),
            );
          } else {
            return SizedBox();
          }
        },
      ));


  Widget _FlashintoProduct({ProductData item, int index}) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(
            " "+item.name+" ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FunctionHelper.FontTheme(
                color: Colors.black, fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize().sp),
          ),
          SizedBox(height: 5),
          Text(
            "฿${item.salePrice}",
            style: FunctionHelper.FontTheme(
                color: ThemeColor.ColorSale(), fontWeight: FontWeight.bold,fontSize: SizeUtil.priceFontSize().sp),
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    padding:
                    EdgeInsets.only(left: 15, right: 7, bottom: 3, top: 3),
                    color: ThemeColor.ColorSale(),
                    child: Text("${item.saleCount!=null?item.saleCount.toString():'0'} ${LocaleKeys.my_product_sold_end.tr()}" ,
                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailSmallFontSize().sp,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/svg/flash.svg',
                width: 8.0.w,
                height: 8.0.w,
              )
            ],
          )
        ],
      ),
    );
  }



  Widget _buildProduct({ProductData item, int index, BuildContext context}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        width: (MediaQuery.of(context).size.width / 2) - 15,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Hero(
                  tag: "flash_${index}",
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black.withOpacity(0.1), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(1.0.h),
                      child: CachedNetworkImage(
                        width: 28.0.w,
                        height: 35.0.w,
                        placeholder: (context, url) => Container(
                          width: 28.0.w,
                          height: 35.0.w,
                          color: Colors.white,
                          child:
                          Lottie.asset(Env.value.loadingAnimaion,   width: 28.0.w,
                            height: 35.0.w,),
                        ),
                        imageUrl: ProductLandscape.CovertUrlImage(item.image),
                        errorWidget: (context, url, error) => Container(
                            width: 28.0.w,
                            height: 35.0.w,
                            child: Icon(
                              Icons.error,
                              size: 30,
                            )),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      child: Container(
                        margin: EdgeInsets.all(1.5.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1.0.w),
                          child: Container(
                            padding: EdgeInsets.only(right: 1.5.w,left: 1.5.w,top: 1.0.w,bottom: 1.0.w),
                            color: ThemeColor.ColorSale(),
                            child: Text("${item.discountPercent}%",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
                          ),
                        ),
                      ),
                      visible: item.discountPercent>0?true:false,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _FlashintoProduct(item: item, index: index)
          ],
        ),
      ),
      onTap: (){

        AppRoute.ProductDetail(context,
            productImage: "flash_${index}",
            productItem: ProductBloc.ConvertDataToProduct(data: item));
      },
    );
  }

  List<ProductData> ConvertProductData(){
    List<ProductData> data = List<ProductData>();
    for(var item in widget.instalData.data[0].items){
      data.add(item.product);
    }
    return data;
  }


}

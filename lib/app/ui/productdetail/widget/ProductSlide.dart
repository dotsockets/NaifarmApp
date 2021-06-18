import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class ProductSlide extends StatefulWidget {
  final List<String> imgList;
  final int indexImg;
  final int stockQuantity;

  const ProductSlide({Key key, this.imgList,this.indexImg=0,this.stockQuantity=1}) : super(key: key);
  @override
  _ProductSlideState createState() => _ProductSlideState();
}

class _ProductSlideState extends State<ProductSlide> {
  final current = BehaviorSubject<int>();

  @override
  void initState() {
    current.add(widget.indexImg);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          _buildBanner(),
          widget.imgList.isNotEmpty ? _buildIndicator() : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 0, bottom: 30),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 50.0.h,
              viewportFraction: 0.999,
              autoPlay: true,
              initialPage: widget.indexImg,
              enableInfiniteScroll: widget.imgList.length > 1 ? true : false,
              autoPlayInterval: Duration(seconds: 7),
              onPageChanged: (index, reason) {
                current.add(index);
              },
            ),
            items: widget.imgList
                .map(
                  (item) => Container(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset('assets/json/loading.json', height: 30),
                  ),
                  imageUrl: item,
                  errorWidget: (context, url, error) => Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: NaifarmErrorWidget()),
                ),
              ),
            )
                .toList(),
          ),
        ),
        widget.stockQuantity==null || widget.stockQuantity==0?Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Container(
              color: Colors.white.withOpacity(0.7),
              child: Center(
                child: Container(
                  width: 20.0.w,
                  height: 4.0.h,
                  padding: EdgeInsets.all(2.0.w),
                  decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius:
                      new BorderRadius.all(Radius.circular(10.0.w))),
                  child: Center(
                    child: Text(
                        LocaleKeys.search_product_out_of_stock.tr(),
                        style: FunctionHelper.fontTheme(
                            fontSize: SizeUtil.detailFontSize().sp,
                            color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ):SizedBox()
      ],
    );
  }

  Widget _buildIndicator() => Positioned(
        bottom: 5,
        //  left: MediaQuery.of(context).size.width/2*0.86,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: current.stream,
            builder: (_,snapShot){
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imgList
                      .asMap()
                      .map((key, value) {
                    return MapEntry(
                        key,
                        Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black.withOpacity(0.6)),
                            shape: BoxShape.circle,
                            color: snapShot.hasData && snapShot.data == key
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ));
                  })
                      .values
                      .toList());
            },
          ),
        ),
      );
}

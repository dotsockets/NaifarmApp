import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/NaifarmErrorWidget.dart';
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
  //final List<String> _imgList = <String>[];

  int _current;

  @override
  void initState() {
    _current = widget.indexImg;
    super.initState();
    // for (var item in widget.imgList) {
    //   _imgList.add("${Env.value.baseUrl}/storage/images/${item.path}");
    // }
    // if (widget.imgList.isEmpty) {
    //   _imgList.add(Env.value.noItemUrl);
    // }
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
                setState(() {
                  _current = index;
                });
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
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: NaifarmErrorWidget()),
                  // errorWidget: (context, url, error) =>
                  //     Image.network(Env.value.noItemUrl, fit: BoxFit.cover),
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
          child: Row(
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
                            color: _current == key
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ));
                  })
                  .values
                  .toList()),
        ),
      );
}

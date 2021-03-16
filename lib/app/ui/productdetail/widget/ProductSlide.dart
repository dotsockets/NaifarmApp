import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:sizer/sizer.dart';

class ProductSlide extends StatefulWidget {
  final List<ProductImage> imgList;

  const ProductSlide({Key key, this.imgList}) : super(key: key);
  @override
  _ProductSlideState createState() => _ProductSlideState();
}

class _ProductSlideState extends State<ProductSlide> {
  final List<String> _imgList = <String>[];

  int _current;

  @override
  void initState() {
    _current = 0;
    super.initState();
    for (var item in widget.imgList) {
      _imgList.add("${Env.value.baseUrl}/storage/images/${item.path}");
    }
    if (widget.imgList.isEmpty) {
      _imgList.add(Env.value.noItemUrl);
    }
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
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 3, bottom: 30),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 40.0.h,
          viewportFraction: 0.999,
          autoPlay: true,
          enableInfiniteScroll: widget.imgList.length > 1 ? true : false,
          autoPlayInterval: Duration(seconds: 7),
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items: _imgList
            .map(
              (item) => Container(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset('assets/json/loading.json', height: 30),
                  ),
                  imageUrl: item,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) =>
                      Image.network(Env.value.noItemUrl, fit: BoxFit.cover),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildIndicator() => Positioned(
        bottom: 5,
        //  left: MediaQuery.of(context).size.width/2*0.86,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imgList
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

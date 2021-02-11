
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';
import 'package:sizer/sizer.dart';


class BannerSlide extends StatelessWidget {
  final List<String> image;
  BannerSlide({Key key, this.image}) : super(key: key);

  final List<String> _imgList = [
    'https://www.img.in.th/images/317d8380f24ff1950566bc4029933b62.jpg'
  ];

  List<String> ConvertSliderImage(){
    return image.isNotEmpty?image:_imgList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 28.0.h,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 0,bottom: 2.0.w),
          decoration: new BoxDecoration(
              color: ThemeColor.primaryColor(),
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(30.0),
                  bottomRight: const Radius.circular(30.0)
              )
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.945,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 7),
              onPageChanged: (index, reason) {
                // setState(() {
                //   _current = index;
                // });
              },
            ),
            items: ConvertSliderImage()
                .map(
                  (item) => Container(
                margin: EdgeInsets.only(left: 1.0.h,right: 1.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.0.h),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Lottie.asset('assets/json/loading.json',height: 23.0.h),
                        ),
                        fit: BoxFit.cover,
                        imageUrl: item,
                        height: 25.0.h,
                        errorWidget: (context, url, error) => Container(color: Colors.white,height: 23.0.h,child: Icon(Icons.error,size: 5.0.h,)),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .toList(),
          ),
        )
      ],
    );
  }
}

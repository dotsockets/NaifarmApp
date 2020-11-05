
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';

class BannerSlide extends StatelessWidget {
  final List<String> _imgList = [
    'https://www.img.in.th/images/317d8380f24ff1950566bc4029933b62.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 3,bottom: 30),
      decoration: new BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: new BorderRadius.only(
            bottomLeft: const Radius.circular(40.0),
            bottomRight: const Radius.circular(40.0)
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
        items: _imgList
            .map(
              (item) => Container(
                margin: EdgeInsets.only(left: 6,right: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl: item,
                    errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
                  ),
                ),
              ),
        )
            .toList(),
      ),
    );
  }
}

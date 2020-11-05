
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';

class ProductSlide extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: [
        BannerSection()
      ],
    );
  }
}



  class BannerSection extends StatefulWidget {
  @override
  _BannerSectionState createState() => _BannerSectionState();
  }

  class _BannerSectionState extends State<BannerSection> {

  final List<String> _imgList = [
    'https://www.img.in.th/images/7fc6ff825238293be21ea341e2f54755.png',
    'https://www.img.in.th/images/7fc6ff825238293be21ea341e2f54755.png',
    'https://www.img.in.th/images/7fc6ff825238293be21ea341e2f54755.png'
  ];

  int _current;

  @override
  void initState() {
    _current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBanner(),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildBanner(){
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.only(top: 3,bottom: 30),
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 0.945,
          autoPlay: true,
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
            margin: EdgeInsets.only(left: 6,right: 6),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                width: MediaQuery.of(context).size.width,
                child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
              ),
              fit: BoxFit.cover,
              imageUrl: item,
              errorWidget: (context, url, error) => Container(height: 30,child: Icon(Icons.error,size: 30,)),
            ),
          ),
        )
            .toList(),
      ),
    );
  }


  Widget _buildIndicator() => Positioned(
    bottom: 10,
  //  left: MediaQuery.of(context).size.width/2*0.86,
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _imgList.asMap().map((key, value){
          return MapEntry(key, Container(
            width: 13,
            height: 13,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.6)),
              shape:  BoxShape.circle,
              color: _current==key?Colors.black:Colors.transparent,
            ),
          ));
        }).values.toList()
      ),
    ),
  );

}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';

class BannerSlide extends StatelessWidget {
  final List<String> image;

  BannerSlide({Key key, this.image}) : super(key: key);

  final List<String> _imgList = [
    'https://www.img.in.th/images/317d8380f24ff1950566bc4029933b62.jpg'
  ];

  final _current = BehaviorSubject<int>();

  List<String> convertSliderImage() {
    return image.isNotEmpty ? image : _imgList;
  }

  @override
  Widget build(BuildContext context) {
    _current.add(0);
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 32.0.w,
                autoPlay: true,
                viewportFraction: 1,
                autoPlayInterval: Duration(seconds: 7),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.elasticIn,
                onPageChanged: (index, reason) {
                  _current.add(index);
                },
              ),
              items: convertSliderImage()
                  .map(
                    (item) => CachedNetworkImage(
                      imageUrl: item,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Lottie.asset('assets/json/loading.json'),
                      ),
                      errorWidget: (context, url, error) => Container(
                          color: Colors.white,
                          child: Icon(
                            Icons.error,
                            size: 5.0.h,
                          )),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: _current.stream,
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: convertSliderImage().map((url) {
                            int index = convertSliderImage().indexOf(url);
                            return Container(
                              width: 3.0.h,
                              height: 0.5.h,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: snapshot.data == index
                                    ? Colors.white
                                    : Colors.white60,
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return SizedBox();
                      }
                    })
              ],
            ),
          ),
        )
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/ui/productdetail/widget/ProductSlide.dart';
import 'package:naifarm/utility/SizeUtil.dart';

import 'NaifarmErrorWidget.dart';

class ImageFullScreen extends StatelessWidget {
  final String tagHero;
  final List<String> imgList;
  final int indexImg;

  const ImageFullScreen({Key key, this.tagHero, this.imgList,this.indexImg=0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            child: Hero(
              tag: tagHero,
              child: Center(
                child:
                    imgList.length <=1
                        ? CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                              child: Lottie.asset('assets/json/loading.json',
                                  width: 60, height: 60),
                            ),
                            fit: BoxFit.cover,
                            imageUrl: imgList != null ? imgList[0] : "",
                            errorWidget: (context, url, error) => tagHero=="image_profile_me"||tagHero=="image_profile"?Container(
                                width: 60,
                                height: 60,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffE6E6E6),
                                  radius: 30,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                )): Container(
                                width: 60,
                                height: 60,
                                //child: Image.network(Env.value.noItemUrl, fit: BoxFit.cover)),
                                child: NaifarmErrorWidget()),
                          )
                        : ProductSlide(imgList: imgList,indexImg: indexImg,),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Positioned(
            top: 50,
            right: 30,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                FontAwesome5.window_close,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}

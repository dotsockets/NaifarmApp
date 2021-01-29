
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/config/Env.dart';

class ImageFullScreen extends StatelessWidget {
  final String image;
  final String hero_tag;

  const ImageFullScreen({Key key, this.image,this.hero_tag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      body:Stack(
        children: [
          GestureDetector(
            child: Center(
              child: Hero(
                  tag: hero_tag,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      color: Colors.white,
                      child:
                      Lottie.asset(Env.value.loadingAnimaion,width: 30, height: 30),
                    ),
                    fit: BoxFit.cover,
                    imageUrl: image,
                    errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundColor: Color(0xffE6E6E6),
                          radius: 30,
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            color: Color(0xffCCCCCC),
                          ),
                        )),
                  )
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
              onPressed: ()=>Navigator.pop(context),
              icon: Icon(FontAwesome5.window_close,color: Colors.white,size: 30,),
            ),
          )
        ],
      ),
    );
  }
}
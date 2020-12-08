

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/FollowersModel.dart';
import 'package:naifarm/app/viewmodels/ReviewViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class FollowersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppToobar(
        title: "ผู้ติดตาม",
        header_type: Header_Type.barNormal,
        icon: 'assets/images/svg/search.svg',
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: ReviewViewModel().getFollower().asMap().map((key, value) => MapEntry(key, _BuildCard(item: ReviewViewModel().getFollower()[key],context: context))).values.toList(),
          ),
        ),
      )
    );
  }

  Widget _BuildCard({FollowersModel item,BuildContext context}){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(right: 15,left: 15,top: 5,bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      placeholder: (context, url) => Container(
                        color: Colors.white,
                        child:
                        Lottie.asset(Env.value.loadingAnimaion, height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: item.Image,
                      errorWidget: (context, url, error) => Container(
                          height: 30,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(item.Name,style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.bold,fontSize: SizeUtil.titleSmallFontSize()),)
                ],
              ),
              Container(
                child: FlatButton(
                  color: item.IsFollow?Colors.white:ThemeColor.primaryColor(),
                  textColor: item.IsFollow?ThemeColor.primaryColor():Colors.white,
                  padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: ThemeColor.primaryColor()),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  onPressed: () {
                    AppRoute.Followers(context);
                  },
                  child: Text(
                    item.IsFollow?"กำลังติดตาม":"ติดตาม",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(color: Colors.grey.shade500,)
      ],
    );
  }
}

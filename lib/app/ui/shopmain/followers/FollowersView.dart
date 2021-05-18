import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/FollowersModel.dart';
import 'package:naifarm/app/viewmodels/ReviewViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class FollowersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppToobar(
          title: LocaleKeys.shop_follower.tr(),
          headerType: Header_Type.barNormal,
          icon: 'assets/images/png/search.png',
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: ReviewViewModel()
                  .getFollower()
                  .asMap()
                  .map((key, value) => MapEntry(
                      key,
                      buildCard(
                          item: ReviewViewModel().getFollower()[key],
                          context: context)))
                  .values
                  .toList(),
            ),
          ),
        ));
  }

  Widget buildCard({FollowersModel item, BuildContext context}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 5),
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
                        child: Lottie.asset('assets/json/loading.json',
                            height: 30),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: item.image,
                      errorWidget: (context, url, error) => Container(
                          height: 30,
                          child: Icon(
                            Icons.error,
                            size: 30,
                          )),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    item.name,
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeUtil.titleSmallFontSize().sp),
                  )
                ],
              ),
              Container(
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(color: ThemeColor.primaryColor()),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10)),
                    backgroundColor: MaterialStateProperty.all(
                      item.isFollow ? Colors.white : ThemeColor.primaryColor(),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.followers(context);
                  },
                  child: Text(
                    item.isFollow
                        ? LocaleKeys.shop_following.tr()
                        : LocaleKeys.shop_follow.tr(),
                    style: FunctionHelper.fontTheme(
                        color: item.isFollow
                            ? ThemeColor.primaryColor()
                            : Colors.white,
                        fontSize: SizeUtil.titleSmallFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade500,
        )
      ],
    );
  }
}

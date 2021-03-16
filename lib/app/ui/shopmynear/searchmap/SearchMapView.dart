import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class SearchMapView extends StatefulWidget {
  final String locationTxt;

  const SearchMapView({Key key, this.locationTxt}) : super(key: key);

  @override
  _SearchMapViewState createState() => _SearchMapViewState();
}

class _SearchMapViewState extends State<SearchMapView> {
  List<String> searchList = [
    "Toyota Tsusho (Thailand) Co.,Ltd",
    "A Space Asoke-Ratchada",
    "เซนทัล พระราม9"
  ];
  List<String> listClone = <String>[];

  @override
  void initState() {
    super.initState();
    listClone.addAll(searchList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppToobar(
          icon: "",
          isEnableSearch: true,
          locationTxt: widget.locationTxt,
          headerType: Header_Type.barMap,
          onSearch: (String text) {
            setState(() {
              searchText(text);
            });
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildLocation(),
              Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listClone.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(listClone[index],
                              style: FunctionHelper.fontTheme(
                                  color: Colors.black,
                                  fontSize: SizeUtil.titleFontSize().sp)),
                          padding: EdgeInsets.all(15),
                        ),
                        buildLine()
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLine() {
    return Container(
      height: 2,
      color: Colors.grey.shade100,
    );
  }

  Widget buildLocation() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          buildBlockLocation(
              description: "คอนโด เอสเปส...",
              title: LocaleKeys.map_home.tr(),
              iconTxt: 'assets/images/svg/home_active.svg'),
          SizedBox(
            width: 10,
          ),
          buildBlockLocation(
              description: "คอนโด เอสเปส...",
              title: LocaleKeys.map_office.tr(),
              iconTxt: 'assets/images/svg/work.svg'),
        ],
      ),
    );
  }

  Widget buildBlockLocation(
      {String title, String description, String iconTxt}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          SvgPicture.asset(
            iconTxt,
            color: ThemeColor.secondaryColor(),
            width: 30,
            height: 30,
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: FunctionHelper.fontTheme(
                      color: Colors.black,
                      fontSize: SizeUtil.titleFontSize().sp)),
              Text(description,
                  style: FunctionHelper.fontTheme(
                      color: Colors.grey,
                      fontSize: SizeUtil.titleSmallFontSize().sp)),
            ],
          )
        ],
      ),
    );
  }

  void searchText(String text) {
    listClone.clear();
    for (int i = 0; i < searchList.length; i++) {
      if (searchList[i].contains(text)) {
        listClone.add(searchList[i]);
      }
    }
  }
}

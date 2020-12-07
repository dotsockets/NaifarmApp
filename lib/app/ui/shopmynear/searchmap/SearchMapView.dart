import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

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
  List <String> listClone = List<String>();

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
          isEnable_Search: true,
          locationTxt: widget.locationTxt,
          header_type: Header_Type.barMap,
          onSearch: (String text){
            setState(() {
              SearchText(text);
            });
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _BuildLocation(),
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
                              style: FunctionHelper.FontTheme(
                                  color: Colors.black, fontSize: SizeUtil.titleFontSize())),
                          padding: EdgeInsets.all(15),
                        ),
                        _BuildLine()
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

  Widget _BuildLine() {
    return Container(
      height: 2,
      color: Colors.grey.shade100,
    );
  }

  Widget _BuildLocation() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          _BuildBlockLocation(description: "คอนโด เอสเปส...", title: "บ้านฉัน",iconTxt: 'assets/images/svg/home_active.svg'),
          SizedBox(width: 10,),
          _BuildBlockLocation(description: "คอนโด เอสเปส...", title: "ที่ทำงาน",iconTxt: 'assets/images/svg/work.svg'),
        ],
      ),
    );
  }

  Widget _BuildBlockLocation({String title, String description,String iconTxt}) {
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
          SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: FunctionHelper.FontTheme(
                      color: Colors.black, fontSize: SizeUtil.titleFontSize())),
              Text(description,
                  style: FunctionHelper.FontTheme(
                      color: Colors.grey, fontSize: SizeUtil.titleSmallFontSize()
                  )),
            ],
          )
        ],
      ),
    );
  }
  void SearchText(String text){
      listClone.clear();
      for(int i=0;i<searchList.length;i++){
        if(searchList[i].contains(text)){
          listClone.add(searchList[i]);
        }
      }

    }
}

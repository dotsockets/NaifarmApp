import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/ui/recommend/widget/SearchHot.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';


class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<String> searchList = ["น้ำตาลปีบ", "น้ำปลาหวาน", "กุ้งฝอย", "ผักกาด","พริก"];
  List <String> listClone = List<String>();
  bool checkSeemore = false;
  TextEditingController txtController = TextEditingController();
  @override
  void initState() {
    super.initState();
    listClone.addAll(searchList);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
         appBar: AppToobar(
           icon: "",
           isEnable_Search: false,
           header_type: Header_Type.barHome,
           hint: LocaleKeys.search_product_title.tr(),
           onSearch: (String text){
             setState(() {
               SearchLike(text);
             });
           },

         ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: !checkSeemore&&listClone.length!=0&&listClone.length>3?3:listClone.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                              child: Text(listClone[index], style: FunctionHelper.FontTheme(color: Colors.black, fontSize: SizeUtil.titleSmallFontSize())
                                ),
                            ),
                            _BuildLine()
                          ],
                        );
                      },
                    ),
                  ),
                  InkWell(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top:10,bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Visibility(
                          child: Text(listClone.length==0?LocaleKeys.search_product_not_found.tr():checkSeemore?LocaleKeys.search_product_hide.tr():LocaleKeys.search_product_show.tr(),
                              style: FunctionHelper.FontTheme(color: Colors.grey, fontSize: SizeUtil.titleSmallFontSize())),
                        visible: listClone.length>0&&listClone.length<=3?false:true,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        checkSeemore ? checkSeemore = false : checkSeemore = true;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SearchHot(onSelectChang: () {})
                ],
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

      color: Colors.grey.shade50,
    );
  }

  void SearchLike(String text){
    listClone.clear();
    for(int i=0;i<searchList.length;i++){
      if(searchList[i].contains(text)){
        listClone.add(searchList[i]);
      }
    }

  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/ui/recommend/widget/SearchHot.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

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
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppToobar(
            icon: "",
            isEnable_Search: false,
            header_type: Header_Type.barHome,
            hint: "ค้นหาสินค้า",
            onSearch: (String text){
              setState(() {
                SearchLike(text);
              });
            },

          ),
          body: SingleChildScrollView(
            child: Column(
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
                              child: Text(listClone[index], style: FunctionHelper.FontTheme(color: Colors.black, fontSize: SizeUtil.titleSmallFontSize())
                              ),padding: EdgeInsets.all(10),
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
                        child: Text(listClone.length==0?"ไม่พบข้อมูล":checkSeemore?"ย่อ":"แสดงเพิ่ม",
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

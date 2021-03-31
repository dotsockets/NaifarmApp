import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:sizer/sizer.dart';
import '../SizeUtil.dart';

// ignore: must_be_immutable
class OrderTypeDropdownList extends StatefulWidget {
  String title;
  String txtSelect;
  List<String> dataList;
  Function(int, String) onSelect;
  int initialItem;
  CategoriesAllRespone categoriesAllRespone;

  OrderTypeDropdownList(
      {Key key,
      this.txtSelect = "",
      this.title = "เลือกหมวดหมู่",
      this.dataList,
      this.onSelect,
      this.initialItem = 0,
      this.categoriesAllRespone})
      : super(key: key);

  @override
  _OrderTypeDropdownListState createState() => _OrderTypeDropdownListState();
}

class _OrderTypeDropdownListState extends State<OrderTypeDropdownList>
    with SingleTickerProviderStateMixin {
  int selectedValue;

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //color: ThemeColor.dialogprimaryColor(context),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.categoriesAllRespone.data
                  .asMap()
                  .entries
                  .map((e) => itemRow(item: e.value))
                  .toList()),
        ),
      ),
    );
  }

  Container itemRow({CategoriesAllData item}) => Container(
        child: Column(
          children: item.categorySubGroups
              .asMap()
              .map((key, value) => MapEntry(
                  key,
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade300,
                        child: Center(
                            child: Text(
                          "[${item.name} : ${value.name}]",
                          style: FunctionHelper.fontTheme(
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      Column(
                        children: value.category
                            .asMap()
                            .entries
                            .map((e) => subItemRow(item: e.value, index: e.key))
                            .toList(),
                      ),
                    ],
                  )))
              .values
              .toList(),
        ),
      );

  Container subItemRow({Category item, int index}) => Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          child: Text("- " + item.name,
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp)),
          onTap: () {
            FocusScope.of(context).unfocus();
            widget.onSelect(item.id, item.name);
          },
        ),
      );
}

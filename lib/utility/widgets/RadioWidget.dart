import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

import '../SizeUtil.dart';

class RadioWidget extends StatefulWidget {
  final List<RadioData> data;
  final Function onSelected;
  final dynamic initailValue;
  RadioWidget(
      {Key key,
      @required this.data,
      @required this.onSelected,
      this.initailValue})
      : super(key: key);

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  final listRadioData = BehaviorSubject<List<RadioData>>();

  @override
  void dispose() {
    listRadioData.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.length > 0) {
      if (widget.initailValue != null) {
        var initValue =
            widget.data.firstWhere((e) => e.value == widget.initailValue);
        if (initValue != null) {
          initValue.isSelected = true;
        }
      } else {
        widget.data[0].isSelected = true;
      }
      listRadioData.add(widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(
          color: Colors.black.withOpacity(0.5),
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: StreamBuilder(
          stream: listRadioData.stream,
          builder: (BuildContext context, AsyncSnapshot listSnap) {
            if (listSnap.hasData) {
              return Column(
                children: listSnap.data
                    .map<Widget>(
                      (e) => InkWell(
                        onTap: () {
                          listSnap.data.any((e) => e.isSelected = false);
                          e.isSelected = true;
                          listRadioData.add(listSnap.data);
                          widget.onSelected(e.value);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                child: Center(
                                  child: Container(
                                    width: 15.0,
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.5),
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: e.isSelected
                                        ? Container(
                                            margin: EdgeInsets.all(3.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ThemeColor.primaryColor(),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 40.0,
                                child: Text(
                                  e.text,
                                  style: FunctionHelper.fontTheme(
                                      fontSize:
                                          SizeUtil.titleSmallFontSize().sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}

class RadioData {
  String text = "";
  dynamic value;
  bool isSelected;
  RadioData(this.text, this.value, {this.isSelected = false});
}

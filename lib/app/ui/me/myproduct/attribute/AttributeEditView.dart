import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class AttributeEditView extends StatefulWidget {
  final int idAttr;
  final String nameAttr;

  const AttributeEditView({Key key, this.idAttr, this.nameAttr})
      : super(key: key);

  @override
  _AttributeEditViewState createState() => _AttributeEditViewState();
}

class _AttributeEditViewState extends State<AttributeEditView> {
  UploadProductBloc bloc;
  TextEditingController attrController = TextEditingController();
  List<TextEditingController> subAttrController = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final onAddSubType = BehaviorSubject<bool>();
  final onCheck = BehaviorSubject<bool>();
  int total = 0;

  @override
  void initState() {
    super.initState();
  }

  init() {
    if (bloc == null) {
      attrController.text = widget.nameAttr;
      onCheck.add(false);
      onAddSubType.add(false);
      bloc = UploadProductBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        if (event is SubAttributeData) {
          Navigator.pop(context, true);
        } else if (event is AttributeData) {
          Navigator.pop(context, true);
        }
      });
      bloc.attributeMyShop.stream.listen((event) {
        subAttrController.clear();
        total = event.total;
        event.total != 0
            ? event.data.asMap().forEach((index, value) {
                subAttrController.add(TextEditingController());
                subAttrController[index].text = value.value;
                onAddSubType.add(true);
                onCheck.add(false);
              })
            : subAttrController.add(TextEditingController());
      });
      bloc.onError.stream.listen((event) {
        // FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event);
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
      Usermanager().getUser().then((value) => bloc.getSubAttribute(context,
          token: value.token, id: widget.idAttr));
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(6.5.h),
            child: AppToobar(
              title: LocaleKeys.add.tr() + LocaleKeys.attributes_list.tr(),
              icon: "",
              isEnableSearch: false,
              headerType: Header_Type.barNormal,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildEdittext(),
                SizedBox(
                  height: 0.3.h,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 2.0.h, bottom: 2.0.h, right: 10, left: 10),
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 2.0.h),
                            child: Text(
                              "${LocaleKeys.attributes_label.tr()}:",
                              style: FunctionHelper.fontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 3.0.w,
                          ),
                          StreamBuilder(
                              stream: onAddSubType.stream,
                              builder: (context, snapshot) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder(
                                        stream: bloc.attributeMyShop.stream,
                                        builder: (context, snapshot) {
                                          var item = (snapshot.data
                                              as MyShopAttributeRespone);
                                          // _check();
                                          return Column(
                                            children: List.generate(
                                                subAttrController.length,
                                                (index) => Container(
                                                      child: _buildEdittextDel(
                                                          index: index,
                                                          item: item),
                                                    )),
                                          );
                                        }),
                                    if (snapshot.hasData)
                                      _buildAddAttribute(snapshot.data)
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildSaveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddAttribute(bool isSnapshot) {
    return InkWell(
      onTap: () {
        if (isSnapshot) {
          subAttrController.add(TextEditingController());
          onAddSubType.add(false);

        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color:
              isSnapshot ? ThemeColor.secondaryColor() : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              "+",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              " " + LocaleKeys.attributes_add.tr(),
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleSmallFontSize().sp,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEdittextDel({int index, MyShopAttributeRespone item}) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.0.h),
      color: Colors.white,
      child: Row(
        children: [
          _buildEdittextList(index: index),
          SizedBox(
            width: 3.0.w,
          ),
          InkWell(
            onTap: () {
              if (index < total) {
                _delSubAttr(index: index, item: item);
              } else {
                subAttrController.removeAt(index);
                onAddSubType.add(true);
              }
            },
            child: Image.asset(
              'assets/images/png/trash.png',
              width: SizeUtil.smallIconSize().w,
              height: SizeUtil.smallIconSize().w,
              color: ThemeColor.colorSale(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEdittext({double sizeTxt = 83.0}) {
    return Container(
      padding: EdgeInsets.only(top: 4.0.h, bottom: 4.0.h, right: 10, left: 10),
      color: Colors.white,
      child: Row(
        children: [
          Text(
            "${LocaleKeys.my_profile_name.tr()}:",
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 3.0.w,
          ),
          Container(
            width: sizeTxt.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black.withOpacity(0.5))),
            child: TextFormField(
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp),
              decoration: InputDecoration(
                  isDense: true,
                  hintStyle: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(2.0.h)),
              onChanged: (String x) => _check(),
              controller: attrController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEdittextList({double sizeTxt = 70, int index}) {
    return Container(
      width: sizeTxt.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.5))),
      child: TextFormField(
        style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp),
        decoration: InputDecoration(
            isDense: true,
            hintStyle: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(2.0.h)),
        onChanged: (String x) => _check(),
        controller: subAttrController[index],
      ),
    );
  }

  Widget _buildSaveButton() {
    return StreamBuilder(
        stream: onCheck.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.only(top: 2.0.h),
              child: Center(
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(50.0.w, 5.0.h),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      snapshot.data
                          ? ThemeColor.secondaryColor()
                          : Colors.grey.shade400,
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    if (snapshot.data) {
                      FocusScope.of(context).unfocus();
                      if (widget.nameAttr.trim() != attrController.text.trim()) {
                        _updateNameAttr();
                      }
                      HashMap<int,String> valueUpdateList = new HashMap<int, String>();
                      List.generate(
                          total,
                          (index) => subAttrController[index].text.isNotEmpty && subAttrController[index].text.trim() != bloc.attributeMyShop.value.data[index].value.trim()
                              ? valueUpdateList[index] = subAttrController[index].text:null);

                      if (valueUpdateList.isNotEmpty) {
                          _updateSubAttr(valueList: valueUpdateList);
                      }
                      if (subAttrController.length > total) {
                        addSubAttr();
                      }
                    }
                  },
                  child: Text(
                    LocaleKeys.btn_save.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }

  void _check() {
    if (subAttrController.length != 0) {
      subAttrController[subAttrController.length - 1].text.trim().isNotEmpty
          ? onAddSubType.add(true)
          : onAddSubType.add(false);
    } else
      onAddSubType.add(true);

    attrController.text.trim().length != 0
        ? onCheck.add(true)
        : onCheck.add(false);
  }

  _updateNameAttr() {
    Usermanager().getUser().then((value) => bloc.updateAttribute(context,
        id: widget.idAttr, token: value.token, name: attrController.text));
  }

  _delSubAttr({int index, MyShopAttributeRespone item}) {
    Usermanager().getUser().then((value) => bloc.deleteSubAttribute(context,
        id: widget.idAttr, token: value.token, vid: item.data[index].id));
  }

  _updateSubAttr({HashMap<int,String> valueList,}) {

    List.generate(valueList.length, (index) {

      Usermanager().getUser().then((value) => bloc.updateSubAttribute(context,
          value: valueList.values.elementAt(index),
          id: widget.idAttr,
          token: value.token,
          total: valueList.length,
          index: widget.nameAttr.trim() == attrController.text.trim() &&
              subAttrController.length == total
              ? index
              : -1,
          color: "",
          vid:  bloc.attributeMyShop.value.data[valueList.keys.elementAt(index)].id));
    });

  }

  addSubAttr() {
    if (subAttrController.length - total > 0 &&
        subAttrController[total].text.isNotEmpty) {
      for (int i = total; i < subAttrController.length; i++) {
        subAttrController[i].text.isNotEmpty
            ? Usermanager().getUser().then((value) => bloc.addSubAttribute(
                context,
                value: subAttrController[i].text,
                id: widget.idAttr,
                token: value.token,
                length: widget.nameAttr.trim() == attrController.text.trim()?subAttrController.length - total:-1,
                color: ""))
            : null;
      }
    }
  }
}

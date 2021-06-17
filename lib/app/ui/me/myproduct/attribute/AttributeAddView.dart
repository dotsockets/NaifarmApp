import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/AttributeRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class AttributeAddView extends StatefulWidget {
  const AttributeAddView({Key key}) : super(key: key);

  @override
  _AttributeAddViewState createState() => _AttributeAddViewState();
}

class _AttributeAddViewState extends State<AttributeAddView> {
  UploadProductBloc bloc;
  TextEditingController attrController = TextEditingController();
  List<TextEditingController> subAttrController = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final onAddSubType = BehaviorSubject<bool>();
  final onCheck = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();
  }

  init() {
    if (bloc == null) {
      _initialValue();
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
      bloc.onError.stream.listen((event) {
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event);
      });
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
            preferredSize: Size.fromHeight(7.0.h),
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
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 2.0.h),
                              child: Text(
                                "${LocaleKeys.attributes_label.tr()}:",
                                style: FunctionHelper.fontTheme(
                                    fontSize: SizeUtil.titleFontSize().sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: StreamBuilder(
                                stream: onAddSubType.stream,
                                builder: (context, snapshot) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(

                                        child: Column(
                                          children: List.generate(
                                              subAttrController.length,
                                              (index) => Container(
                                                    child: _buildEdittextDel(
                                                        index: index),
                                                  )),
                                        ),
                                      ),
                                      if (snapshot.hasData)
                                        _buildAddAttribute(snapshot.data)
                                    ],
                                  );
                                }),
                          ),
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
          //  isAddForm = false;
          //  onCheck.add(false);
        }
      },
      child: Container(
        width: 30.0.w,
        padding: EdgeInsets.only(top: 6, bottom: 6),
        decoration: BoxDecoration(
          color:
              isSnapshot ? ThemeColor.secondaryColor() : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildEdittextDel({int index}) {
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
              subAttrController.removeAt(index);
              onAddSubType.add(true);
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

  Widget _buildEdittext() {
    return Container(
      padding: EdgeInsets.only(top: 4.0.h, bottom: 4.0.h, right: 10, left: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "${LocaleKeys.my_profile_name.tr()}:",
              style: FunctionHelper.fontTheme(
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              margin: EdgeInsets.all(1.0.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
          )
        ],
      ),
    );
  }

  Widget _buildEdittextList({int index}) {
    return Expanded(
      flex: 4,
      child: Container(
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

                      // List<String> valueList = <String>[];
                      // List.generate(subAttrController.length, (index) => subAttrController[index].text.isNotEmpty
                      //     ? valueList.add(subAttrController[index].text) : null);
                      //
                      // subAttrController.map((e) => e.text.isNotEmpty ? valueList.add(e.text) : null).toList();

                      Usermanager().getUser().then((value) =>
                          bloc.addAttributeMyShop(context,
                              name: attrController.text,
                              token: value.token,
                              value: subAttrController.map((e) => e.text.isNotEmpty ? e.text : null).toList(),
                              color: ""));
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

    attrController.text.trim().length != 0 ? onCheck.add(true) : onCheck.add(false);
  }

  _initialValue() {
    subAttrController.add(TextEditingController());
    onCheck.add(false);
    onAddSubType.add(false);
  }
}

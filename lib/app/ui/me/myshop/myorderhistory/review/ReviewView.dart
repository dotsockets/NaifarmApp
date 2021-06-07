import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/AssetImages.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:naifarm/utility/widgets/CustomStarRating.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class ReviewView extends StatefulWidget {
  final OrderData orderData;

  const ReviewView({Key key, this.orderData}) : super(key: key);

  @override
  _ReviewViewState createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TextEditingController> reviewController = [];
  bool selectSwitch = false;
  List<Asset> images = <Asset>[];
  OrdersBloc bloc;
  final rateValue = BehaviorSubject<int>();
  List<int> rating = [];
  int selectIndex;

  //ExpandedTileController _controller;
  //List<bool> isShowItem = [];

  void initState() {
    // _iconHide.add(false);
    //  _controller = ExpandedTileController();
    initialValue();
    super.initState();
  }

  init() {
    if (bloc == null) {
      bloc = OrdersBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if (event) {
          FunctionHelper.showDialogProcess(context);
        } else {
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        // Navigator.pop(context, true);
        FunctionHelper.snackBarShow(
            context: context,
            scaffoldKey: _scaffoldKey,
            message: LocaleKeys.noti_playment_success.tr());
      });
      bloc.onError.stream.listen((event) {
        // FunctionHelper.snackBarShow(scaffoldKey: _scaffoldKey, message: event);
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
          appBar: AppToobar(
            title: LocaleKeys.noti_rate_purchase.tr(),
            headerType: Header_Type.barNormal,
            isEnableSearch: false,
            icon: '',
          ),
          body: ListView.builder(
              itemCount: widget.orderData.items.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionPanelList(
                  expansionCallback: (int i, bool status) {
                    setState(() {
                      selectIndex = selectIndex == index ? null : index;
                    });
                  },
                  children: [
                    new ExpansionPanel(canTapOnHeader: true,
                      isExpanded: selectIndex == index,
                      headerBuilder: (BuildContext context,
                          bool isExpanded) =>
                      new Container(
                          padding: EdgeInsets.only(left: 2.5.w,top: 1.0.h,bottom: 1.0.h),
                          child: header(index: index, context: context
                          )),
                      body: ratingChild(index),),
                  ],
                );
              }),

          // body: ListView(
          //     key: Key('builder ${selectIndex.toString()}'),
          //     children: List.generate(
          //       widget.orderData.items.length,
          //           (index) => ListTileTheme(
          //           contentPadding:
          //           EdgeInsets.only(left: 4.0.w, right: 0.5.w),
          //           tileColor: Colors.white,
          //           child: ratingTile(index)),
          //     ))
        ),
      ),
    );
  }

  Widget ratingTile(int index) {
    return ExpansionTile(
      initiallyExpanded: selectIndex == index && selectIndex != -1,
      backgroundColor: Colors.white,
      //  initiallyExpanded: isShowItem[0],
      // trailing: SizedBox.shrink(),

      trailing: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 0.5.w),
        width: SizeUtil.iconLargeSize().w,

        child: StreamBuilder(
            stream: rateValue.stream,
            builder: (context, snapshot) {
              return Icon(
                //isShowItem[index]
                selectIndex ==index
                    ? Icons.keyboard_arrow_down_outlined
                    : Icons.keyboard_arrow_right,
                color: Colors.grey.withOpacity(0.7),
                size: SizeUtil.iconLargeSize().w,

              );
            }),
      ),
      onExpansionChanged: ((c) {
        // _iconHide.add(c);
        //rating[index] = 0;
        // isShowItem[index] = c;
        if (c) {
          selectIndex = index;
        } else {
          selectIndex = -1;
        }
        rateValue.add(index);
      }),
      title: header(index: index, context: context),
      children: <Widget>[
        ratingChild(index)
      ],
    );
  }

  Widget ratingChild(int index){
    return Column(
      children: [
        Divider(
          color: Colors.grey.shade300,
          thickness: 0.2.h,
        ),
        StreamBuilder(
            stream: bloc.isUpdateFeedback.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData ||
                  widget.orderData.items[index].feedbackId == null) {
                return bloc.feedbackMap[index] == null &&
                    widget.orderData.items[index].feedbackId == null
                    ? _buildInputForm(index)
                    : SizedBox();
              }
              return Text("-",
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500));
            }),
        SizedBox(
          height: 1.5.h,
        ),
        Container(
          color: Colors.grey.shade300,
          height: 0.5.h,
        )
      ],
    );
  }

  Widget _buildInputForm(int index) {
    return Column(
      children: [
        buildForm(context, index),
        //hideNameRate(),
        _buildBtnSend(index),
      ],
    );
  }

  Widget hideNameRate() {
    return Container(
      padding: EdgeInsets.only(right: 2.0.w, left: 2.0.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.0.w),
              Text(LocaleKeys.review_anonymous.tr(),
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleFontSize().sp,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 1.0.w),
              Text("${LocaleKeys.review_username.tr()}: farnmarket@mail.com",
                  style: FunctionHelper.fontTheme(
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.black.withOpacity(0.5))),
              SizedBox(
                height: 20,
              )
            ],
          ),
          FlutterSwitch(
            height: SizeUtil.switchHeight(),
            width: SizeUtil.switchWidth(),
            toggleSize: SizeUtil.switchToggleSize(),
            activeColor: Colors.grey.shade200,
            inactiveColor: Colors.grey.shade200,
            toggleColor:
                selectSwitch ? ThemeColor.primaryColor() : Colors.grey.shade400,
            value: selectSwitch ? true : false,
            onToggle: (val) {
              setState(() {
                selectSwitch = !selectSwitch;
              });
            },
          )
        ],
      ),
    );
  }

  Future<void> loadAssets({int maxImages}) async {
    // ignore: unused_local_variable
    List<Asset> resultList = <Asset>[];
    // ignore: unused_local_variable
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImages,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Review",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      images.addAll(resultList);
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future captureFile(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        // fileImage = File(pickedFile.path);
        print("${File(pickedFile.path)}");
        // Usermanager().getUser().then((value) => bloc.UploadImage(context: context,imageFile: fileImage,imageableType: "customer",imageableId: itemInfo.id,token: value.token));
      } else {
        print('No file selected.');
      }
    });
  }

  Widget header({int index, BuildContext context}) {
    return Container(
      //padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
      color: Colors.white,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(LocaleKeys.order_detail_order_num.tr(),style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.bold),),
          //     Text("09988203dergd4",style: FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp,color: ThemeColor.colorSale(),fontWeight: FontWeight.bold),),
          //
          //   ],
          // ),
          // SizedBox(height: 10,),
          // Container(
          //   padding: EdgeInsets.only(left: 15,top: 15,bottom: 5,right: 20),
          //   color: Colors.white,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           ClipRRect(
          //             borderRadius: BorderRadius.all(Radius.circular(20)),
          //             child: CachedNetworkImage(
          //               width: 25,
          //               height: 25,
          //               placeholder: (context, url) => Container(
          //                 color: Colors.white,
          //                 child: Lottie.asset('assets/json/loading.json', height: 30),
          //               ),
          //               fit: BoxFit.cover,
          //               imageUrl: item.ProfiletImage,
          //               errorWidget: (context, url, error) => Container(
          //                   height: 30,
          //                   child: Icon(
          //                     Icons.error,
          //                     size: 30,
          //                   )),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Text(item.shopName,
          //               style:
          //               FunctionHelper.fontTheme(fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold))
          //         ],
          //       ),
          //
          //     ],
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                    tag: "history_$index",
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 23.0.w,
                          height: 23.0.w,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child: Lottie.asset(
                              'assets/json/loading.json',
                              width: 23.0.w,
                              height: 23.0.w,
                            ),
                          ),
                          fit: BoxFit.contain,
                          imageUrl: widget
                                      .orderData.items[index].itemImagePath !=
                                  null
                              ? "${Env.value.baseUrl}/storage/images/${widget.orderData.items[index].itemImagePath}"
                              : Env.value.noItemUrl,
                          errorWidget: (context, url, error) => Container(
                              height: 30,
                              child: Icon(
                                Icons.error,
                                size: 30,
                              )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48.0.w,
                        child: Text(widget.orderData.items[index].itemTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: 0.5.h),
                      StreamBuilder(
                          stream: bloc.isUpdateFeedback.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData ||
                                widget.orderData.items[index].feedbackId !=
                                    null) {
                              return bloc.feedbackMap[index] != null
                                  ? starRate(rate: bloc.feedbackMap[index])
                                  : widget.orderData.items[index].feedbackId ==
                                          null
                                      ? reviewTxt()
                                      : starRate(rate: 4);
                            } else
                              return reviewTxt();
                          })
                      // Text("ตัวเลือกสินค้า: ดำ, XL",
                      //     style: FunctionHelper.fontTheme(
                      //         fontSize: SizeUtil.titleSmallFontSize().sp,
                      //         color: Colors.black.withOpacity(0.5))),
                    ],
                  )
                ],
              ),
              // StreamBuilder(
              //     stream: _iconHide.stream,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return Icon(
              //           snapshot.data
              //               ? Icons.keyboard_arrow_down_outlined
              //               : Icons.arrow_forward_ios_sharp,
              //           color: Colors.grey.withOpacity(0.7),
              //           size: SizeUtil.ratingSize().w,
              //         );
              //       } else {
              //         return SizedBox();
              //       }
              //     })
            ],
          ),
        ],
      ),
    );
  }

  Widget reviewTxt() {
    return Text(LocaleKeys.me_menu_rate.tr(),
        style: FunctionHelper.fontTheme(
            fontSize: SizeUtil.titleSmallFontSize().sp,
            color: ThemeColor.colorSale().withOpacity(0.7)));
  }

  Widget starRate({int rate = 3}) {
    return CustomStarRating(
        allowHalfRating: false,
        onRated: (v) {},
        starCount: 5,
        rating: rate.toDouble(),
        size: 3.0.w,
        isReadOnly: true,
        filledIconData: 'assets/images/svg/star_active.svg',
        halfFilledIconData: 'assets/images/svg/star_unactive.svg',
        color: Colors.amber,
        borderColor: Colors.amber,
        spacing: 0.0);
  }

  Widget buildForm(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(bottom: 1.0.h, top: 1.0.h),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Text(
            LocaleKeys.review_rate.tr(),
            style: FunctionHelper.fontTheme(
                fontSize: SizeUtil.titleFontSize().sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          CustomStarRating(
              allowHalfRating: false,
              onRated: (v) {
                rating[index] = v.toInt();
                rateValue.add(index);
              },
              starCount: 5,
              rating: rating[index].toDouble(),
              size: 9.0.w,
              isReadOnly: false,
              filledIconData: 'assets/images/svg/star_active.svg',
              halfFilledIconData: 'assets/images/svg/star_unactive.svg',
              color: Colors.amber,
              borderColor: Colors.amber,
              spacing: 0.0),
          Divider(
            color: Colors.grey.shade300,
            thickness: 0.2.h,
          ),
          SizedBox(
            height: 10,
          ),
          // Divider(
          //   color: Colors.black.withOpacity(0.5),
          // ),

          Container(
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                    padding: EdgeInsets.all(2.0.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: ThemeColor.secondaryColor(), width: 1)),
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: ThemeColor.secondaryColor(),
                          size: SizeUtil.iconSmallSize().w,
                        ),
                        Text(LocaleKeys.btn_add_image.tr(),
                            style: FunctionHelper.fontTheme(
                                fontSize: SizeUtil.titleFontSize().sp,
                                fontWeight: FontWeight.w500,
                                color: ThemeColor.secondaryColor())),
                      ],
                    ),
                  ),
                  onTap: () {
                    loadAssets(maxImages: 10);
                  },
                )),
                // Expanded(
                //     child: InkWell(
                //   child: Container(
                //     margin: EdgeInsets.only(left: 1.0.w, right: 2.0.w),
                //     padding: EdgeInsets.all(2.0.w),
                //     decoration: BoxDecoration(
                //         border: Border.all(
                //             color: ThemeColor.secondaryColor(), width: 1)),
                //     child: Column(
                //       children: [
                //         Icon(
                //           FontAwesome.video_camera,
                //           color: ThemeColor.secondaryColor(),
                //         ),
                //         Text(LocaleKeys.btn_add_vdo.tr(),
                //             style: FunctionHelper.fontTheme(
                //                 fontSize: SizeUtil.titleFontSize().sp,
                //                 fontWeight: FontWeight.w500,
                //                 color: ThemeColor.secondaryColor())),
                //       ],
                //     ),
                //   ),
                //   onTap: () {
                //     captureFile(ImageSource.gallery);
                //   },
                // ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w, top: 1.0.h),
            // child: Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(
            //       color:  Colors.black.withOpacity(0.5),),),
            //   child: TextFormField(
            //     maxLines: 5,
            //       controller: reviewController[index],
            //       decoration: InputDecoration(
            //           isDense: true,
            //           // important line
            //           hintStyle: FunctionHelper.fontTheme(
            //               fontSize: SizeUtil.titleFontSize().sp,
            //               color: Colors.grey),
            //           hintText: selectIndex == index
            //               ? LocaleKeys.review_tell.tr() + ratingValue(selectIndex)
            //               : LocaleKeys.review_tell.tr() + ratingValue(index),
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.all(2.0.h)),
            //       style: FunctionHelper.fontTheme(
            //           fontSize: SizeUtil.titleFontSize().sp),
            //       onChanged: (String char) {
            //         setState(() {});
            //       }
            //       // setState(() {
            //       //
            //       // });
            //
            //       ),
            //
            //
            // ),
            child: StreamBuilder(
              stream: rateValue.stream,
              builder: (context, snapshot) {
                return BuildEditText(
                  head: "",
                  maxLength: 5000,
                  hint: selectIndex == index
                      ? LocaleKeys.review_tell.tr() + ratingValue(selectIndex)
                      : LocaleKeys.review_tell.tr() + ratingValue(index),
                  maxLine: 5,
                  controller: reviewController[index],
                  inputType: TextInputType.text,
                  onChanged: (String char) {
                    setState(() {});
                  },
                );
              }
            ),
          ),

          SizedBox(
            height: 1.0.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                margin: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildButtonreview(
                        title: LocaleKeys.review_quality.tr(), index: index
                        // onClick: () => reviewController.text =
                        //     LocaleKeys.review_quality.tr()
                        ),
                    SizedBox(
                      width: 10,
                    ),
                    buildButtonreview(
                        title: LocaleKeys.review_value.tr(), index: index
                        // onClick: () =>
                        //     reviewController.text = LocaleKeys.review_value.tr()
                        ),
                    SizedBox(
                      width: 10,
                    ),
                    buildButtonreview(
                      title: LocaleKeys.review_deli.tr(), index: index,
                      // onClick: () =>
                      //     reviewController.text = LocaleKeys.review_deli.tr()
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonreview({String title = "", Function() onClick, int index}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Colors.grey.shade300,
        ),
        overlayColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.3),
        ),
      ),
      onPressed: () {
        //onClick();
      },
      child: StreamBuilder(
          stream: rateValue.stream,
          builder: (context, snapshot) {
            return Text(
              snapshot.data == index
                  ? title + ratingValue(snapshot.data)
                  : title + ratingValue(index),
              style: FunctionHelper.fontTheme(
                  color: Colors.black,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            );
          }),
    );
  }

  Widget _buildBtnSend(int index) {
    return Container(
      height: 5.0.h,
      child: StreamBuilder(
          stream: rateValue.stream,
          builder: (context, snapshot) {
            return TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.only(
                  left: 20.0.w,
                  right: 20.0.w,
                )),
                backgroundColor: MaterialStateProperty.all(
                  _checkReview(index)
                      ? ThemeColor.secondaryColor()
                      : Colors.grey.shade400,
                ),
                overlayColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.3),
                ),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                List<AssetImages> convertImg = <AssetImages>[];
                for (var imgList in images) {
                  convertImg.add(AssetImages(imgList.identifier, imgList.name,
                      imgList.originalWidth, imgList.originalHeight));
                }
                if (_checkReview(index)) {
                  Usermanager().getUser().then((value) => bloc.addFeedback(
                      context,
                      comment: reviewController[index].text,
                      rating: rating[index],
                      token: value.token,
                      orderId: widget.orderData.id,
                      imageList: convertImg,
                      index: index,
                      inventoryId: widget.orderData.items[index].inventoryId));
                }
              },
              child: Text(
                LocaleKeys.btn_confirm.tr(),
                style: FunctionHelper.fontTheme(
                    color: Colors.white,
                    fontSize: SizeUtil.titleFontSize().sp,
                    fontWeight: FontWeight.w500),
              ),
            );
          }),
    );
  }

  initialValue() {
    for (var i = 0; i < widget.orderData.items.length; i++) {
      reviewController.add(TextEditingController());
      rating.add(0);
      //isShowItem.add(false);
    }
  }

  bool _checkReview(int index) {
    if (reviewController[index].text.trim().length >= 10 &&
        rating[index] != 0) {
      return true;
    } else {
      return false;
    }
  }

  String ratingValue(int index) {
    switch (rating[index]) {
      case 0:
        return "";
        break;
      case 1:
        return LocaleKeys.review_terrible.tr();
        break;
      case 2:
        return LocaleKeys.review_bad.tr();
        break;
      case 3:
        return LocaleKeys.review_ok.tr();
        break;
      case 4:
        return LocaleKeys.review_good.tr();
        break;
      case 5:
        return LocaleKeys.review_ex.tr();
        break;
    }
  }
}

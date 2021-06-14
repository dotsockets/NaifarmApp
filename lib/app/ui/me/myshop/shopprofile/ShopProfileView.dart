import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/MyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/ImageUploadRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:sizer/sizer.dart';
import "package:naifarm/app/model/core/ExtensionCore.dart";

class ShopProfileView extends StatefulWidget {
  @override
  _ShopprofileState createState() => _ShopprofileState();
}

class _ShopprofileState extends State<ShopProfileView> with RouteAware {
  MemberBloc bloc;
  List<String> datalist = ["ชาย", "หญิง"];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MyShopRespone itemInfo = MyShopRespone();
  bool onUpdate = false;
  bool isSelect = true;
  File fileImage;
  bool onImageUpdate = false;

  @override
  void initState() {
    super.initState();
  }

  void _init(BuildContext context) {
    if (null == bloc) {
      _getCustomerInfo();
      bloc = MemberBloc(AppProvider.getApplication(context));
      _getCusStorage();
      bloc.onLoad.stream.listen((event) {
      });
      bloc.onError.stream.listen((event) {
        onUpdate = false;
        FunctionHelper.alertDialogShop(context,
            title: LocaleKeys.btn_error.tr(), message: event.message);
      });
      bloc.onSuccess.stream.listen((event) {
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   Usermanager().getUser().then((value) =>  context.read<InfoCustomerBloc>().loadCustomInfo(token:value.token));
        // });

        if (event is ImageUploadRespone) {
          setState(() {
            onImageUpdate = true;
            itemInfo.image[0].path = event.path;
          });
        } else if (event is MyShopRespone) {
          _loadCusData();
        }
        //widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });

      // Usermanager().getUser().then((value) =>  context.read<InfoCustomerBloc>().loadCustomInfo(token:value.token));

    }
  }

  void onSave({MyShopRespone itemInfo, bool onLoad = true}) {
    if (onUpdate || onImageUpdate) {
      Usermanager().getUser().then((value) => bloc.myShopUpdate(
          context: context,
          data: MyShopRequest(
              name: itemInfo.name,
              description: itemInfo.description,
              slug: itemInfo.slug,
              legalName: itemInfo.legalName,
              externalUrl: itemInfo.externalUrl,
              stateId: itemInfo.state != null ? itemInfo.state.id : 0,
              active: isSelect ? 1 : 0),
          accessToken: value.token));
      if (onLoad) {
        Navigator.pop(context, true);
      }
    } else {
      Navigator.pop(context, onImageUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    return WillPopScope(
      onWillPop: () async {
        onSave(itemInfo: itemInfo, onLoad: true);
        return true;
      },
      child: Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
          bottom: false,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.grey.shade200,
              body: BlocBuilder<InfoCustomerBloc, InfoCustomerState>(
                builder: (_, item) {
                  if (item is InfoCustomerLoaded) {
                    itemInfo = item.profileObjectCombine.myShopRespone;
                    return contentMe(itemInfo: itemInfo);
                  } else if (item is InfoCustomerLoading) {
                    itemInfo = item.profileObjectCombine.myShopRespone;
                    return contentMe(itemInfo: itemInfo);
                  } else if (item is InfoCustomerError) {
                    itemInfo = item.profileObjectCombine.myShopRespone;
                    return contentMe(itemInfo: itemInfo);
                  } else {
                    return SizedBox();
                  }
                },
              )),
        ),
      ),
    );
  }

  Widget contentMe({MyShopRespone itemInfo}) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(
                  Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  onSave(itemInfo: itemInfo, onLoad: true);
                },
              )),
          expandedHeight: SizeUtil.meBodyHeight(220),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: ThemeColor.primaryColor(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    LocaleKeys.edit.tr() + LocaleKeys.shop_title.tr(),
                    style: FunctionHelper.fontTheme(
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      child: fileImage == null
                          ? CachedNetworkImage(
                              width: (SizeUtil.iconSize() * 2).w,
                              height: (SizeUtil.iconSize() * 2).w,
                              placeholder: (context, url) => Container(
                                width: (SizeUtil.iconSize() * 2).w,
                                height: (SizeUtil.iconSize() * 2).w,
                                color: Colors.white,
                                child: Lottie.asset(
                                  'assets/json/loading.json',
                                  height: (SizeUtil.iconSize() * 2).w,
                                  width: (SizeUtil.iconSize() * 2).w,
                                ),
                              ),
                              fit: BoxFit.cover,
                              imageUrl: itemInfo != null
                                  ? itemInfo.image != null
                                      ? "${itemInfo.image.isNotEmpty ? itemInfo.image[0].path.imgUrl() : ''}"
                                      : ''
                                  : '',
                              errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade300,
                                  width: (SizeUtil.iconSize() * 2).w,
                                  height: (SizeUtil.iconSize() * 2).w,
                                  child: Icon(
                                    Icons.person,
                                    size: SizeUtil.iconSize().w,
                                    color: Colors.white,
                                  )),
                            )
                          : Stack(
                              children: [
                                Container(
                                  width: 20.0.w,
                                  height: 20.0.w,
                                  color: Colors.white,
                                  child: Lottie.asset(
                                      'assets/json/loading.json',
                                      height: 30),
                                ),
                                Image.file(
                                  fileImage,
                                  width: 20.0.w,
                                  height: 20.0.w,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                    ),
                    onTap: () => captureImage(ImageSource.gallery),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(
                          right: 15, left: 15, bottom: 5, top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: ThemeColor.colorSale()),
                      child: Text(LocaleKeys.btn_edit_img.tr(),
                          style: FunctionHelper.fontTheme(
                              color: Colors.white,
                              fontSize: SizeUtil.detailFontSize().sp,
                              fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      captureImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Container(
              child: Column(
                children: [
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    message: itemInfo.name != null ? itemInfo.name : '',
                    title: LocaleKeys.shop_name_title.tr(),
                    onClick: () async {
                      final result = await AppRoute.editNameShop(context,
                          itemInfo: itemInfo);
                      if (result != null) {
                        onUpdate = true;
                        setState(() => itemInfo = result);
                      }
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    message: itemInfo.legalName != null
                        ? itemInfo.legalName.length > 20
                            ? '${itemInfo.legalName.substring(0, 20)}...'
                            : itemInfo.legalName
                        : '',
                    title: LocaleKeys.shop_name_official.tr(),
                    onClick: () async {
                      final result = await AppRoute.officialName(context,
                          itemInfo: itemInfo);
                      if (result != null) {
                        onUpdate = true;
                        setState(() => itemInfo = result);
                      }
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    message: itemInfo.slug != null
                        ? "naifarm.com/${itemInfo.slug}"
                        : "",
                    title: LocaleKeys.shop_slug.tr(),
                    onClick: () async {
                      final result =
                          await AppRoute.editSlug(context, itemInfo: itemInfo);
                      if (result != null) {
                        onUpdate = true;
                        setState(() => itemInfo = result);
                      }
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    message: itemInfo.description != null
                        ? itemInfo.description
                        : '',
                    title: LocaleKeys.shop_detail_title.tr(),
                    onClick: () async {
                      final result = await AppRoute.editDetail(context,
                          itemInfo: itemInfo);
                      if (result != null) {
                        onUpdate = true;
                        setState(() => itemInfo = result);
                      }
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    message: itemInfo.externalUrl != null
                        ? itemInfo.externalUrl
                        : '',
                    title: LocaleKeys.shop_external_link.tr(),
                    onClick: () async {
                      final result = await AppRoute.editExtrlUrl(context,
                          itemInfo: itemInfo);
                      if (result != null) {
                        onUpdate = true;
                        setState(() => itemInfo = result);
                      }
                    },
                  ),
                  _buildLine(),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    message: itemInfo != null
                        ? itemInfo.state != null
                            ? itemInfo.state.name
                            : ''
                        : '',
                    title: LocaleKeys.address_province.tr(),
                    onClick: () async {
                      final result = await AppRoute.editProvice(context,
                          itemInfo: itemInfo);

                      if (result != null) {
                        onUpdate = true;
                        setState(() => itemInfo = result);
                      }
                    },
                  ),
                  _buildLine(num: 10),
                  ListMenuItem(
                    opacityMessage: 0.5,
                    icon: '',
                    selectSwitch: isSelect,
                    isSwitch: (bool select) {
                      onUpdate = false;
                      itemInfo.active = select ? 1 : 0;
                      setState(() => isSelect = select);
                      // OnSave(onLoad: false,itemInfo: itemInfo);
                      Usermanager().getUser().then((value) {
                        bloc.myShopActive(
                            context: context,
                            data: itemInfo.active,
                            accessToken: value.token);
                      });
                    },
                    title: LocaleKeys.shop_status.tr(),
                    onClick: () {
                      // AppRoute.EditpasswordStep1(context);
                    },
                  ),
                ],
              ),
            )
          ]),
        )
      ],
    );
  }

  Widget _buildLine({double num = 0.5}) {
    return Container(
      height: num,
      color: Colors.grey.shade300,
    );
  }

  Future captureImage(ImageSource imageSource) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        fileImage = File(pickedFile.path);
        Usermanager().getUser().then((value) => bloc.uploadImage(
            context: context,
            imageFile: fileImage,
            imageableType: "shop",
            imageableId: itemInfo.id,
            token: value.token));
      } else {
        print('No image selected.');
      }
    });
  }

  _getCusStorage(){
    NaiFarmLocalStorage.getCustomerInfo().then((value) {
      setState(() {
        itemInfo = value.myShopRespone;
        isSelect = value.myShopRespone.active == 1 ? true : false;
      });
    });
  }

  _getCustomerInfo(){
    Usermanager().getUser().then((value) => context
        .read<InfoCustomerBloc>()
        .loadCustomInfo(context, token: value.token));
  }
  _loadCusData(){
    Usermanager().getUser().then((value) => context
        .read<CustomerCountBloc>()
        .loadCustomerCount(context, token: value.token));
    _getCustomerInfo();
  }
}

import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/CartBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/models/BankModel.dart';
import 'package:naifarm/app/models/CartModel.dart';
import 'package:naifarm/app/viewmodels/CartViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class DeliverySelectView extends StatefulWidget {
  final int shopId;
  int select_id;

  DeliverySelectView({Key key, this.shopId, this.select_id}) : super(key: key);
  @override
  _DeliverySelectViewState createState() => _DeliverySelectViewState();
}

class _DeliverySelectViewState extends State<DeliverySelectView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int select = 0;
  CartBloc bloc;

  void _init() {
    if (null == bloc) {
      bloc = CartBloc(AppProvider.getApplication(context));
      bloc.GetShippingsList(context, shopId: widget.shopId);
      // bloc.PaymentList.add(widget.paymentRespone);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.grey.shade200,
            appBar: AppToobar(
                isEnable_Search: false,
                title: "Choose a shipping method",
                header_type: Header_Type.barNormal),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(2.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    StreamBuilder(
                        stream: bloc.Shippings.stream,
                        builder: (context, snapshot) {
                          var item = (snapshot.data as ShippingsRespone);
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Column(
                                  children: item.data[0].rates
                                      .asMap()
                                      .map((index, value) {
                                        return MapEntry(
                                            index,
                                            _buildCardBank(
                                                item: value, index: index));
                                      })
                                      .values
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                _buildAddBtn(
                                    txtBtn: LocaleKeys.add.tr() +
                                        LocaleKeys.card_title.tr(),
                                    indexBtn: 0),
                              ],
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildCardBank({ShippingRates item, int index}) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              onTap: () {
                widget.select_id = 0;
                for (var i = 0;
                    i < bloc.Shippings.value.data[0].rates.length;
                    i++) {
                  if (bloc.Shippings.value.data[0].rates[i].id == item.id) {
                    bloc.Shippings.value.data[0].rates[i].select = true;
                  } else {
                    bloc.Shippings.value.data[0].rates[i].select = false;
                  }
                }

                bloc.Shippings.add(bloc.Shippings.value);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: StatusSelect(select: item.select, id: item.id),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.carrier.name,
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "จะได้รับภายใน ${item.deliveryTakes != null ? item.deliveryTakes : ''}",
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: Text(
                        "฿${NumberFormat("#,##0.00", "en_US").format(item.rate)}",
                        style: FunctionHelper.FontTheme(
                            fontSize: SizeUtil.titleFontSize().sp,
                            color: ThemeColor.ColorSale())),
                  )
                ],
              ),
            )),
        SizedBox(
          height: 1.5.h,
        )
      ],
    );
  }

  Widget StatusSelect({bool select, int id}) {
    if (widget.select_id > 0) {
      return widget.select_id == id
          ? SvgPicture.asset(
              'assets/images/svg/checkmark.svg',
              width: 8.0.w,
              height: 8.0.w,
              color: ThemeColor.primaryColor(),
            )
          : SvgPicture.asset(
              'assets/images/svg/uncheckmark.svg',
              width: 8.0.w,
              height: 8.0.w,
              color: Colors.black.withOpacity(0.5),
            );
    } else {
      return select
          ? SvgPicture.asset(
              'assets/images/svg/checkmark.svg',
              width: 8.0.w,
              height: 8.0.w,
              color: ThemeColor.primaryColor(),
            )
          : SvgPicture.asset(
              'assets/images/svg/uncheckmark.svg',
              width: 8.0.w,
              height: 8.0.w,
              color: Colors.black.withOpacity(0.5),
            );
    }
  }

  Widget _buildAddBtn({String txtBtn, int indexBtn}) {
    return Center(
      child: Container(
          margin: EdgeInsets.all(10),
          width: 50.0.w,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              minimumSize: MaterialStateProperty.all(
                Size(80.0.w, 50.0),
              ),
              backgroundColor: MaterialStateProperty.all(
                ThemeColor.secondaryColor(),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.3),
              ),
            ),
            onPressed: () async {
              ShippingRates item = ShippingRates();
              for (var i = 0;
                  i < bloc.Shippings.value.data[0].rates.length;
                  i++) {
                if (bloc.Shippings.value.data[0].rates[i].select) {
                  item = bloc.Shippings.value.data[0].rates[i];
                }
              }

              Navigator.pop(context, item);
            },
            child: Text(
              "Confirm",
              style: FunctionHelper.FontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.titleFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
          )),
    );
  }
}

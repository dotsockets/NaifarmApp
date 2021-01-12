import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:sizer/sizer.dart';

class MyProductView extends StatefulWidget {
  @override
  _MyProductViewState createState() => _MyProductViewState();
}

class _MyProductViewState extends State<MyProductView> {
  int status = 999;
  List<ProductModel> listProducts = ProductViewModel().getMyProducts();

  ProductBloc bloc;

  init(){
     if(bloc==null){
       bloc=ProductBloc(AppProvider.getApplication(context));
       bloc.loadCategoryGroup();
       Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: "1",limit: 5,token: value.token));
     }
  }


  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppToobar(
            title: LocaleKeys.me_title_my_product.tr(),
            icon: "",
            header_type: Header_Type.barNormal,
          ),
          body: Container(
            color: Colors.grey.shade300,
            child: Column(

              children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: StreamBuilder(
                        stream: bloc.ProductMyShop.stream,
                        builder: (BuildContext context,AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            return Column(
                              children: List.generate(listProducts.length, (index) =>
                                  _BuildProduct(item: listProducts[index],index: index),),
                            );
                          }else{
                            return SizedBox();
                          }
                        },
                      )
                    ),
                  ),
                _BuildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _BuildButton() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        child: FlatButton(
          color: ThemeColor.secondaryColor(),
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          onPressed: () {AppRoute.MyNewProduct(context);},
          child: Text(
            LocaleKeys.add_product_btn.tr(),
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
          ),
        ),
      );
  }

  Widget _BuildProduct(
      {ProductModel item,int index}) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.contain,
                  width: 40.0.w,
                  height: 45.0.w,
                  imageUrl: item.product_image,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product_name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "฿${item.product_price}",
                          style: FunctionHelper.FontTheme(
                              fontSize: SizeUtil.priceFontSize().sp,
                              color: ThemeColor.ColorSale(),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(LocaleKeys.my_product_amount.tr()+" ${item.amoutProduct}",
                                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp)),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "${LocaleKeys.my_product_sold.tr()+" "+item.product_status+" "+LocaleKeys.cart_item.tr()}",
                                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(LocaleKeys.my_product_like.tr()+" 10", style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp)),),
                                SizedBox(width: 10,),
                                Expanded(child: Align(alignment: Alignment.topRight,child: Text(LocaleKeys.my_product_visit.tr()+" 10", style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp),))
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                   Expanded(
                     flex: 2,
                     child:  Text(
                       item.isSelect?LocaleKeys.my_product_sell.tr():LocaleKeys.my_product_break.tr(),
                       style: FunctionHelper.FontTheme(
                           fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w600),
                     ),
                   ),
                    Container(height: 50,color: Colors.grey.shade300,),
                    Expanded(
                      flex: 1,
                      child: FlutterSwitch(
                        height: 9.0.w,
                        toggleSize: 7.0.w,
                        activeColor: Colors.grey.shade200,
                        inactiveColor: Colors.grey.shade200,
                        toggleColor: item.isSelect?ThemeColor.primaryColor():Colors.grey.shade400,
                        value: item.isSelect?true:false,
                        onToggle: (val) {
                          setState(() {
                            listProducts[index].isSelect = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(width: 1,height: 50,color: Colors.grey.shade300,),
                    Expanded(
                       child: InkWell(
                         child: Container(
                           child: SvgPicture.asset(
                             'assets/images/svg/Edit.svg',
                             width: 6.0.w,
                             height: 6.0.w,
                             color: ThemeColor.ColorSale(),
                           ),
                         ),
                       onTap: (){
                           AppRoute.EditProduct(context,index);
                       },
                       ),
                    ),
                    Container(width: 1,height: 50,color: Colors.grey.shade300,),
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/images/svg/trash.svg',
                        width: 6.0.w,
                        height: 6.0.w,
                        color: ThemeColor.ColorSale(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

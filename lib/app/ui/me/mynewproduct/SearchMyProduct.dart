
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';

class SearchMyProduct extends StatefulWidget {
  final int shopID;

  const SearchMyProduct({Key key, this.shopID}) : super(key: key);

  @override
  _SearchMyProductState createState() => _SearchMyProductState();
}

class _SearchMyProductState extends State<SearchMyProduct> {

  List<String> listClone = List<String>();
  bool checkSeemore = false;
  TextEditingController txtController = TextEditingController();
  int limit = 4;
  String SearchText = "";
  ProductBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _init() {
    if (null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onSuccess.stream.listen((event) {
        bloc.loadSearchMyshop(shopId: widget.shopID,page: "1", query: SearchText, limit: limit);
      });

      bloc.onError.stream.listen((event) {
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event.error.message);
      });
      bloc.loadSearchMyshop(shopId: widget.shopID,page: "1", query: SearchText, limit: limit);
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
          appBar: AppToobar(
            icon: "",
            isEnable_Search: false,
            header_type: Header_Type.barHome,
            hint: LocaleKeys.search_product_title.tr(),
            onSearch: (String text) {
              SearchText = text;
              bloc.loadSearchMyshop(shopId: widget.shopID,page: "1", query: text, limit: limit);
            },
          ),
          body: StreamBuilder(
            stream: bloc.SearchProduct.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var item = (snapshot.data as SearchRespone);
              if (snapshot.hasData) {
                if(item.hits.isNotEmpty){
                  return SingleChildScrollView(
                    child: Column(
                      children: item.hits.asMap().map((key, value) => MapEntry(key, _BuildProduct(index: key,item: CovertDataMyShop(hits: value)))).values.toList(),
                    ),
                  );
                }else{
                  return/* Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/json/boxorder.json',
                              height: 70.0.w, width: 70.0.w, repeat: false),
                          Text(
                            LocaleKeys.cart_empty.tr(),
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );*/
                  Center(child: Text("ไม่พบรายการสินค้า",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500,color: Colors.grey),));
                }

              } else {
                return StreamBuilder(
                    stream: bloc.onError.stream,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return Center(
                          child: Text(LocaleKeys.search_product_not_found.tr(),
                              style: FunctionHelper.FontTheme(
                                  fontSize: SizeUtil.titleFontSize().sp,color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                        );
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                );
              }
            },
          ),
        ),
      ),
    );
  }

  ProductMyShop CovertDataMyShop({Hits hits}){
    return ProductMyShop(name: hits.name,id: hits.productId,brand: hits.brand,discountPercent: hits.discountPercent,hasVariant: hits.hasVariant,image: hits.image,maxPrice: hits.maxPrice,
    minPrice: hits.minPrice,offerPrice: hits.offerPrice,rating: hits.rating,reviewCount: hits.reviewCount,saleCount: hits.saleCount,salePrice: hits.salePrice);
  }


  Widget _BuildProduct({ProductMyShop item,int index}) {
    return InkWell(
      onTap: (){
       AppRoute.ProductDetailShop(context,productImage: "myproduct_search_${index}", productItem: item);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1),
                        margin: EdgeInsets.only(right: 10,bottom: 10,top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black.withOpacity(0.2), width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Hero(
                          tag: "myproduct_search_${index}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.h),
                            child: CachedNetworkImage(
                              width: 30.0.w,
                              height: 35.0.w,
                              placeholder: (context, url) => Container(
                                width: 30.0.w,
                                height: 35.0.w,
                                color: Colors.white,
                                child: Lottie.asset(Env.value.loadingAnimaion, width: 30.0.w,
                                  height: 35.0.w,),
                              ),
                              imageUrl: item.image!=null?"${Env.value.baseUrl}/storage/images/${item.image.isNotEmpty?item.image[0].path:''}":'',
                              errorWidget: (context, url, error) => Container(  width: 30.0.w,
                                  height: 35.0.w,child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        child: Container(
                          margin: EdgeInsets.only(left: 2.5.w,top: 4.5.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.w),
                            child: Container(
                              padding: EdgeInsets.only(right: 1.5.w,left: 1.5.w,top: 1.0.w,bottom: 1.0.w),
                              color: ThemeColor.ColorSale(),
                              child: Text("${item.discountPercent}%",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleSmallFontSize().sp),),
                            ),
                          ),
                        ),
                        visible: item.discountPercent>0?true:false,
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 2.0.w,right: 2.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: FunctionHelper.FontTheme(
                                fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            item.offerPrice!=null?"฿${item.offerPrice}":"฿${item.salePrice}",
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
                                  child: Text(LocaleKeys.my_product_amount.tr()+" ${item.stockQuantity!=null?item.stockQuantity:0}",
                                      style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp)),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "${LocaleKeys.my_product_sold.tr()+" "+item.hasVariant.toString()+" "+LocaleKeys.cart_item.tr()}",
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
                                  Expanded(child: Align(alignment: Alignment.topLeft,child: Text(LocaleKeys.my_product_visit.tr()+" 10", style: FunctionHelper.FontTheme(fontSize: SizeUtil.detailFontSize().sp),))
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
                          item.active==1?LocaleKeys.my_product_sell.tr():LocaleKeys.my_product_break.tr(),
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
                          toggleColor: item.active==1?ThemeColor.primaryColor():Colors.grey.shade400,
                          value: item.active==1?true:false,
                          onToggle: (val) {
                            // bloc.ProductMyShop.value.data[index].active = val?1:0;
                            // bloc.ProductMyShop.add(bloc.ProductMyShop.value);
                            // Usermanager().getUser().then((value) =>  bloc.UpdateProductMyShop(shopRequest: ProductMyShopRequest(
                            //     name: item.name,active: bloc.ProductMyShop.value.data[index].active),token: value.token,productId: item.id));
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
                          onTap: () async {
                            // var product = ProductMyShopRequest(name: item.name,salePrice: item.salePrice,stockQuantity: item.stockQuantity,offerPrice: item.offerPrice,active: item.active);
                            // var onSelectItem = List<OnSelectItem>();
                            // for(var value in item.image){
                            //   onSelectItem.add(OnSelectItem(onEdit: false,url: value.path));
                            // }
                            // var result = await  AppRoute.EditProduct(context, item.id,uploadProductStorage: UploadProductStorage(productMyShopRequest: product,onSelectItem: onSelectItem));
                            // if(result){
                            //   Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: "1",limit: 5,token: value.token));
                            // }
                          },
                        ),
                      ),
                      Container(width: 1,height: 50,color: Colors.grey.shade300,),
                      Expanded(
                        child: InkWell(
                          child: SvgPicture.asset(
                            'assets/images/svg/trash.svg',
                            width: 6.0.w,
                            height: 6.0.w,
                            color: ThemeColor.ColorSale(),
                          ),
                          onTap: (){
                            FunctionHelper.ConfirmDialog(context,message: LocaleKeys.dialog_message_del_product.tr(),onClick: (){
                              // bloc.ProductMyShop.value.data.removeAt(index);
                              // bloc.ProductMyShop.add(bloc.ProductMyShop.value);
                               Usermanager().getUser().then((value) => bloc.DELETEProductMyShop(ProductId: item.id,token: value.token));
                               Navigator.of(context).pop();
                            },onCancel: (){Navigator.of(context).pop();});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

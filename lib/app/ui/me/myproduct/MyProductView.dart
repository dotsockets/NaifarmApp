import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductLandscape.dart';
import 'package:naifarm/utility/widgets/Skeleton.dart';
import 'package:sizer/sizer.dart';

class MyProductView extends StatefulWidget {
  @override
  _MyProductViewState createState() => _MyProductViewState();
}

class _MyProductViewState extends State<MyProductView> {
  int status = 999;
  List<ProductModel> listProducts = ProductViewModel().getMyProducts();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  UploadProductBloc bloc;

  init(){
     if(bloc==null){
       bloc=UploadProductBloc(AppProvider.getApplication(context));
       bloc.onSuccess.stream.listen((event)  {
          if(event is bool){
            bloc.ProductMyShop.add(bloc.ProductMyShop.value);
         }
       });
       bloc.onError.stream.listen((event) {
         FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey, message: event);
         Future.delayed(const Duration(milliseconds: 1000), () {
           Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: "1",limit: 5,token: value.token));
         });

       });
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
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            backgroundColor: ThemeColor.primaryColor(),
            title: Text(LocaleKeys.me_title_my_product.tr()),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.search,size: 30,color: Colors.white,),
                onPressed: ()=> AppRoute.SearchMyProductView(context: context),
              ),
              IconButton(
                icon: Icon(FontAwesome.ellipsis_v,size: 30,color: Colors.white,),
              )
            ],
          ),
          body: Container(
            child: Column(
              children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: bloc.ProductMyShop.stream,
                      builder: (BuildContext context,AsyncSnapshot snapshot){
                        if(snapshot.hasData && (snapshot.data as ProductMyShopListRespone).data.length>0){
                          var item = (snapshot.data as ProductMyShopListRespone);
                          return Container(
                            color: Colors.grey.shade300,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(item.data.length, (index) =>
                                    _BuildProduct(item: item.data[index],index: index),),
                              ),
                            ),
                          );
                        }else if(snapshot.connectionState == ConnectionState.waiting){
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Skeleton.LoaderListTite(context)
                              ],
                            ),
                          );
                        }else{
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/json/boxorder.json',
                                    height: 70.0.w, width: 70.0.w, repeat: false),
                                Text(
                                  LocaleKeys.cart_empty.tr(),
                                  style: FunctionHelper.FontTheme(
                                      fontSize: SizeUtil.titleFontSize().sp, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          );
                        }
                      },
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
     margin: EdgeInsets.all(10),
        width: 50.0.w,
        height: 50,
        child: FlatButton(
          height: 50,
          color: ThemeColor.secondaryColor(),
          textColor: Colors.white,
          splashColor: Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () async {
            // index==0?AppRoute.ProductAddType(context):AppRoute.ImageProduct(context);
            var result = await AppRoute.ImageProduct(context,isactive: IsActive.ReplacemenView);
            if(result){
              Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: "1",limit: 5,token: value.token));
            }

          },
          child: Text(
            LocaleKeys.add_product_btn.tr(),
            style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
          ),
        )
      );
  }

  Widget _BuildProduct(
      {ProductMyShop item,int index}) {
    return InkWell(
      onTap: (){
        AppRoute.ProductDetailShop(context,productImage: "myproduct_${index}", productItem: item);

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
                          tag: "myproduct_${index}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.0.h),
                            child: CachedNetworkImage(
                              width: 40.0.w,
                              height: 30.0.w,
                              placeholder: (context, url) => Container(
                                width: 40.0.w,
                                height: 30.0.w,
                                color: Colors.white,
                                child: Lottie.asset(Env.value.loadingAnimaion,height: 30),
                              ),
                              fit: BoxFit.cover,
                              imageUrl: item.image.isNotEmpty?"${Env.value.baseUrl}/storage/images/${item.image[0].path}":'',
                              errorWidget: (context, url, error) => Container( width: 40.0.w,
                                height: 30.0.w,child: Image.network(Env.value.noItemUrl,fit: BoxFit.cover)),
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
                      padding: EdgeInsets.only(left: 10,right: 10),
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
                                  child: Text(LocaleKeys.my_product_amount.tr()+" ${item.stockQuantity}",
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
                           bloc.ProductMyShop.value.data[index].active = val?1:0;
                           bloc.ProductMyShop.add(bloc.ProductMyShop.value);
                            Usermanager().getUser().then((value) =>  bloc.UpdateProductMyShop(shopRequest: ProductMyShopRequest(
                                name: item.name,active: bloc.ProductMyShop.value.data[index].active),token: value.token,productId: item.id));
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
                           var product = ProductMyShopRequest(name: item.name,salePrice: item.salePrice,stockQuantity: item.stockQuantity,offerPrice: item.offerPrice,active: item.active);
                           var onSelectItem = List<OnSelectItem>();
                           for(var value in item.image){
                             onSelectItem.add(OnSelectItem(onEdit: false,url: value.path));
                           }
                           var result = await  AppRoute.EditProduct(context, item.id,uploadProductStorage: UploadProductStorage(productMyShopRequest: product,onSelectItem: onSelectItem));
                            if(result){
                              Usermanager().getUser().then((value) => bloc.GetProductMyShop(page: "1",limit: 5,token: value.token));
                            }
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
                              bloc.ProductMyShop.value.data.removeAt(index);
                              bloc.ProductMyShop.add(bloc.ProductMyShop.value);
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

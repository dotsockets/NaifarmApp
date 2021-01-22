
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ProductMoreView extends StatelessWidget {
  final String barTxt ;
  final List<ProductModel> productList;
  final ProductRespone installData;
  final String api_link;


  ProductMoreView({Key key, this.barTxt,this.productList,this.installData, this.api_link}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppToobar(title:
        barTxt,header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
        body: SingleChildScrollView(
            child: Container(
              child: ProductGrid(titleInto: "",
                  api_link: api_link,
                  productRespone: installData,
                  IconInto: '',
                  onTapItem: (ProductData item,int index) {
                    AppRoute.ProductDetail(context,
                        productImage: "product_more_${item.id}",productItem: ProductBloc.ConvertDataToProduct(data: item));
                  },tagHero: 'product_more' ,EnableHeader: false),
            ),
        ),
      ),
    );
  }
}

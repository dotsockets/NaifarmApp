
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ProductMoreView extends StatelessWidget {
  final String barTxt ;
  final List<ProductModel> productList;

  const ProductMoreView({Key key, this.barTxt,this.productList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
              child: StickyHeader(
                header:  AppToobar(title:
                barTxt,header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
                content: ProductGrid(titleInto: "",
                    producViewModel: productList,
                    IconInto: '',
                    onTapItem: (int index) {
                      AppRoute.ProductDetail(context,
                          productImage: "product_more_${index}");
                    },tagHero: 'product_more' ,EnableHeader: false),
              ),
            ),
        ),
      ),
    );
  }
}

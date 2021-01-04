
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/ProductBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';
import 'package:naifarm/utility/widgets/ProductGrid.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ProductMoreView extends StatefulWidget {
  final String barTxt ;
  final List<ProductModel> productList;
  final ProductRespone installData;

  ProductMoreView({Key key, this.barTxt,this.productList,this.installData}) : super(key: key);


  @override
  _ProductMoreViewState createState() => _ProductMoreViewState();
}

class _ProductMoreViewState extends State<ProductMoreView> {



  ProductBloc bloc;

  void _init(){
    if(null == bloc) {
      bloc = ProductBloc(AppProvider.getApplication(context));
      bloc.ProductPopular.add(widget.installData);
    }

  }

  @override
  Widget build(BuildContext context) {
    _init();
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
              child: StickyHeader(
                header:  AppToobar(title:
                widget.barTxt,header_type:  Header_Type.barNormal,icon: 'assets/images/svg/search.svg',),
                content: StreamBuilder(
                  stream: bloc.ProductPopular.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                       if(snapshot.hasData) {
                         return ProductGrid(titleInto: "",
                             productRespone: snapshot.data,
                             IconInto: '',
                             onTapItem: (int index) {
                               AppRoute.ProductDetail(context,
                                   productImage: "product_more_${index}");
                             },tagHero: 'product_more' ,EnableHeader: false);
                       }else{
                         return SizedBox();
                       }

                  },
                ),
              ),
            ),
        ),
      ),
    );
  }
}

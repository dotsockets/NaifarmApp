import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/viewmodels/ProductViewModel.dart';
import 'package:naifarm/config/Env.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CustomGridView extends StatelessWidget {
  final int lengthRow;
  final Function(int) onTapItem;
  final List<ProductModel> producViewModel;

  const CustomGridView({
    Key key,
    this.onTapItem,
    this.producViewModel,
    this.lengthRow=0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: _buildGridView(context: context)),
    );
  }

  Widget _buildGridView({BuildContext context}) {
    return Container(
      child: Column(
        children: [
          for (int i=0; i<lengthRow*2;i+=2)
            Container(
              child: Row(
                children: List.generate(
                    i==producViewModel.length-1?1:2,
                        (index) => _ProductImage(
                        index: i + index,
                        item: producViewModel[i+index], context: context)
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _ProductImage({ProductModel item, int index,BuildContext context}) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        width: (MediaQuery.of(context).size.width/2),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: index<2?2:0, color: Colors.grey.shade200),
                bottom: BorderSide(width: 2, color: Colors.grey.shade200),
                right: BorderSide(width: 2, color: Colors.grey.shade200),
                left: BorderSide(width: index == 0 ? 2 : 0, color: Colors.grey.shade200))),
        child: Row(
          children: [
            CachedNetworkImage(
              width: 50,
              height: 50,
              placeholder: (context, url) => Container(
                width: 50,
                height: 50,
                color: Colors.white,
                child: Lottie.asset(Env.value.loadingAnimaion, height: 30),
              ),
              fit: BoxFit.cover,
              imageUrl: item.product_image,
              errorWidget: (context, url, error) => Container(
                  height: 30,
                  child: Icon(
                    Icons.error,
                    size: 30,
                  )),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.product_name,
                  overflow: TextOverflow.ellipsis,
                  style: FunctionHelper.FontTheme(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(40),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  item.product_status,
                  overflow: TextOverflow.ellipsis,
                  style: FunctionHelper.FontTheme(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                      fontWeight: FontWeight.normal),
                ),
              ],
            )
          ],
        ),
      ),
      onTap:(){onTapItem(index);} ,
    );
  }
}

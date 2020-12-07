

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/utility/SizeUtil.dart';

class CustomTabBar extends StatelessWidget {
  final List<MenuModel> menuViewModel;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomTabBar({
    Key key,
    this.menuViewModel,
    this.selectedIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.transparent,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      tabs: menuViewModel
          .asMap()
          .map(
            (int index, MenuModel menuModel) {
          final isSelect = index == selectedIndex;


          String text = menuModel.label;

          if (!isSelect && index == 0) {
            text = "หน้าแรก";
          }

          return MapEntry(
            index,
            Tab(
              iconMargin: EdgeInsets.all(0),
              icon: SizedBox(),
              child: Column(
                children: [
                  _buildIcon(
                    path_icon:isSelect ? menuModel.iconSelected : menuModel.icon,
                    color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                    index: index,
                  ),
                  SizedBox(height: 3),
                  _buildLabel(
                    text: text,
                    color: isSelect ?ThemeColor.secondaryColor():Colors.white,
                    wrapText: menuViewModel[0].label == text,
                  ),
                  SizedBox(height: 3),
                  isSelect ?Container(
                    color: Color(ColorUtils.hexToInt("#e85440")),
                    width: 35,
                    height: 5,
                  ):SizedBox()
                ],
              ),
            ),
          );
        },
      )
          .values
          .toList(),
      onTap: onTap,
    );
  }

  Stack _buildIcon({String path_icon, Color color, int index}) => Stack(
    overflow: Overflow.visible,
    children: [
      Stack(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            child: SvgPicture.asset(path_icon,color: color),
          ),
          index==2?Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: ThemeColor.ColorSale(),
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 13,
                minHeight: 13,
              ),
            ),
          ):SizedBox()
        ],
      )
    ],
  );

  Baseline _buildLabel({String text, Color color, bool wrapText}) => Baseline(
    baselineType: TextBaseline.alphabetic,
    child: Text(
      text,
      style: TextStyle(
        fontSize: SizeUtil.detailSmallFontSize(),
        color: color,
        fontWeight: FontWeight.bold,
        letterSpacing: wrapText ? -1.0 : null,
      ),
    ),
    baseline: 12,
  );
}
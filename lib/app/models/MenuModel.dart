import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuModel {
  final String icon;
  final String iconSelected;
  final String label;
  final String page;
  final int type;

  MenuModel({
    this.label,
    this.icon,
    this.iconSelected,
    this.page,
    this.type
  });
}

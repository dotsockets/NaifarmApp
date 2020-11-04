
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';

class CategoryMenu extends StatelessWidget {
  final List<MenuModel> menuViewModel;
  final int selectedIndex;
  final Function(int) onTap;

  const CategoryMenu({Key key, this.menuViewModel, this.selectedIndex, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8,right: 8,bottom: 13,top:8),
      width: MediaQuery.of(context).size.width,
      color: ThemeColor.primaryColor(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(menuViewModel.length, (index){
            return GestureDetector(
              child: Row(
                children: [
                  SizedBox(width: 14),
                  selectedIndex==index?Container(
                    width: 10,
                    height: 10,
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ):SizedBox(),
                  SizedBox(width: 8),
                  Text(menuViewModel[index].label,style: GoogleFonts.sarabun(color: selectedIndex==index?Colors.black:Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),

                ],
              ),
              onTap: (){
                onTap(index);
              },
            );
          }),
        ),
      ),
    );
  }
}

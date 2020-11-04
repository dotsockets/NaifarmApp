import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryMobile.dart';
import 'package:naifarm/app/ui/mycart/MyCartView.dart';
import 'package:naifarm/app/ui/recommend/RecommendMobile.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';

class HomeMobile extends StatefulWidget {
  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  final List<MenuModel> _menuViewModel = MenuViewModel().getTabBarMenus();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _menuViewModel.length,
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              RecommendMobile(size: MediaQuery.of(context).size,paddingBottom: MediaQuery.of(context).padding.bottom,),
              CategoryMobile(),
              MyCartView()
            ],
          ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.5,
                    spreadRadius: 0.5,
                  ),
                ],
                  color: ThemeColor.primaryColor(),
              ),
              child: SafeArea(
                child: CustomTabBar(
                  menuViewModel: _menuViewModel,
                  selectedIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      return _selectedIndex = index;
                    });
                  },
                ),
              ),
            )
        )
    );
  }
}

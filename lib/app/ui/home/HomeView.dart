import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryView.dart';
import 'package:naifarm/app/ui/me/MeView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  List<MenuModel> _menuViewModel;
  int _selectedIndex = 0;
  bool IsLogin = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
  }

  @override
  Widget build(BuildContext context) {



    _menuViewModel = MenuViewModel().getTabBarMenus();
    return DefaultTabController(
        length: _menuViewModel.length,
        child: Scaffold(

          body: IndexedStack(
            index: _selectedIndex,
            children: [
              RecommendView(size: MediaQuery.of(context).size,paddingBottom: MediaQuery.of(context).padding.bottom),
              CategoryView(),
              MyCartView(BtnBack: false,),
              MeView()
            ],
          ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight:  Radius.circular(40),topLeft:  Radius.circular(40)),
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
                    if(index==2){
                      Usermanager().isLogin().then((value) async {
                        if(!value){
                          final result = await  AppRoute.Login(context,IsCallBack: true);
                          if(result){
                            AppRoute.MyCart(context, true);
                          }
                        }else{
                          AppRoute.MyCart(context, true);
                        }
                      });
                    }else{
                      setState(() {
                        _selectedIndex = index;
                      });
                    }

                  },
                ),
              ),
            )
        )
    );
  }
}

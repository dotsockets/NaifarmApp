import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryView.dart';
import 'package:naifarm/app/ui/me/MeView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';



class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  List<MenuModel> _menuViewModel;
  bool IsLogin = true;
  final _selectedIndex = BehaviorSubject<int>();




  init(){
    _menuViewModel = MenuViewModel().getTabBarMenus();
    Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
    NaiFarmLocalStorage.getNowPage().then((value){
      _selectedIndex.add(value);
      NaiFarmLocalStorage.saveNowPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    init();

    return DefaultTabController(
        length: _menuViewModel.length,
        child: Scaffold(
          body:  StreamBuilder(
            stream: _selectedIndex.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return IndexedStack(
                index: snapshot.data,
                children: [
                  RecommendView(size: MediaQuery.of(context).size,paddingBottom: MediaQuery.of(context).padding.bottom),
                  CategoryView(),
                  //MyCartView(BtnBack: false,),
                  NotiView(),
                  MeView()
                ],
              );

            },
          ),
            bottomNavigationBar: StreamBuilder(
              stream: _selectedIndex.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  child: Container(
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
                        selectedIndex: snapshot.data,
                        onTap: (index) {
                          if(index==2){
                            Usermanager().isLogin().then((value) async {
                              if(!value){
                                NaiFarmLocalStorage.saveNowPage(2);
                                final result = await  AppRoute.Login(context,IsCallBack: true);
                                if(result){
                                  AppRoute.MyCart(context, true);
                                  _selectedIndex.add(index);
                                }else{
                                  NaiFarmLocalStorage.saveNowPage(0);
                                }
                              }else{
                                // AppRoute.MyCart(context, true);
                                _selectedIndex.add(index);
                              }
                            });
                          }else{
                            _selectedIndex.add(index);
                          }

                        },
                      ),
                    ),
                  ),
                );

              },
            )
        )
    );
  }


}

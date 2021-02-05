import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/NotiBloc.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/app/ui/category/CategoryView.dart';
import 'package:naifarm/app/ui/category/detail/CategoryDetailView.dart';
import 'package:naifarm/app/ui/me/MeView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/recommend/RecommendView.dart';
import 'package:naifarm/app/viewmodels/MenuViewModel.dart';
import 'package:naifarm/utility/widgets/CustomTabBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:sizer/sizer.dart';


class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  List<MenuModel> _menuViewModel;
  bool IsLogin = true;
  final _selectedIndex = BehaviorSubject<int>();

  NotiBloc bloc;


  init(){



    if(bloc==null){
      //Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
      _menuViewModel = MenuViewModel().getTabBarMenus();
      bloc = NotiBloc(AppProvider.getApplication(context));
      NaiFarmLocalStorage.getNowPage().then((value){
        _selectedIndex.add(value);
        NaiFarmLocalStorage.saveNowPage(0);
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    init();

    return WillPopScope(
      onWillPop: ()async{
        FunctionHelper.ConfirmDialog(context,message: "Do you want to exit an App",onClick: (){
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },onCancel: (){
          Navigator.pop(context, true);
        });
        return false;
      },
      child: DefaultTabController(
          length: _menuViewModel.length,
          child: Scaffold(
            body:  StreamBuilder(
              stream: _selectedIndex.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return IndexedStack(
                  index: snapshot.data,
                  children: [
                    RecommendView(size: MediaQuery.of(context).size,paddingBottom: MediaQuery.of(context).padding.bottom,onClick: (int index){
                      if(index==2){
                        NaiFarmLocalStorage.saveNowPage(index);
                        _selectedIndex.add(index);
                      }
                    }),
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
                  return Container(
                    height: 10.0.h,
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

                         // Usermanager().getUser().then((value) => context.read<CustomerCountBloc>().loadCustomerCount(token: value.token));
                          NaiFarmLocalStorage.saveNowPage(index);
                            _selectedIndex.add(index);


                        },
                      ),
                    ),
                  );

                },
              )
          )
      ),
    );
  }


}

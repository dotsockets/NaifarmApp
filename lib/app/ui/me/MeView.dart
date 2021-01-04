import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppComponent.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';
import 'package:naifarm/utility/widgets/MD2Indicator.dart';
import 'myshop/MyshopView.dart';
import 'purchase/PurchaseView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';


class MeView extends StatefulWidget {
  @override
  _MeViewState createState() => _MeViewState();
}

class _MeViewState extends State<MeView> with RouteAware  {

  bool IsLogin = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     setState(() {
       ISLogin();
     });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }



  @override
  void didPopNext() {
    setState(()=>{ISLogin()});
  }


  void ISLogin() async => IsLogin = await Usermanager().isLogin();




  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
            body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Container(
                margin: EdgeInsets.only(left: 5.0.w),
                child: GestureDetector(
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,size: 7.0.w
                  ),
                  onTap: (){
                    AppRoute.SettingProfile(context, IsLogin);
                  },
                ),
              ),
              actions: [
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 2.5.w,top: 2.0.w),
                    child:
                    BuildIconShop(size: 7.0.w,)
                  ),
                  onTap: (){
                    AppRoute.MyCart(context,true);
                  },
                ),

              ],
              expandedHeight: ScreenUtil().setHeight(IsLogin?75.0.h:65.0.h),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: ThemeColor.primaryColor(),
                  child: IsLogin?Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          width: 10.0.h,
                          height: 10.0.h,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                            child: Lottie.asset(Env.value.loadingAnimaion,
                                height: 30),
                          ),
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS_rDu4Nc6GLkHxx1h3h7NV-skFgSoaV7Ltgw&usqp=CAU",
                          errorWidget: (context, url, error) => Container(
                              height: 30,
                              child: Icon(
                                Icons.error,
                                size: 30,
                              )),
                        ),
                      ),
                      SizedBox(height: 2.0.h),
                      Text("วีระชัย ใจกว้าง",
                          style: FunctionHelper.FontTheme(
                              color: Colors.white,
                              fontSize: SizeUtil.titleFontSize().sp,
                              fontWeight: FontWeight.bold))
                    ],
                  ):_FormLogin(),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                  height: IsLogin?700:500,
                  color: Colors.white,
                  child: DefaultTabController(
                    length: 2,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            child: Container(
                              // color: ThemeColor.psrimaryColor(context),
                              child: TabBar(
                               indicatorColor: ThemeColor.ColorSale(),
                               /* indicator: MD2Indicator(
                                  indicatorSize: MD2IndicatorSize.tiny,
                                  indicatorHeight: 5.0,
                                  indicatorColor: ThemeColor.ColorSale(),
                                ),*/
                                isScrollable: false,
                                tabs: [
                                  _tabbar(title: LocaleKeys.me_tab_buy.tr(),message: false),
                                  _tabbar(title: LocaleKeys.me_tab_shop.tr(),message: false)
                                ],
                              ),
                            ),
                          ),

                          // create widgets for each tab bar here
                          Expanded(
                            child: TabBarView(
                              children: [
                                PurchaseView(IsLogin: IsLogin,),
                                MyshopView(IsLogin: IsLogin,)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            )
          ],
        )),
      ),
    );
  }

  Widget _FormLogin(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                minWidth: 160,
                height: 50,
                color: ThemeColor.ColorSale(),
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: () {
                  AppRoute.Login(context,IsCallBack: true);
                },
                child: Text(LocaleKeys.login_btn.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(width: 20,),
              FlatButton(
                minWidth: 160,
                height: 50,
                color: ThemeColor.secondaryColor(),
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: () {
                  AppRoute.Register(context);
                },
                child: Text(LocaleKeys.register_btn.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        )
      ],
    );
  }


  Widget _tabbar({String title,bool message}){
    return Tab(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,style: FunctionHelper.FontTheme(fontWeight: FontWeight.w500,fontSize: SizeUtil.titleSmallFontSize().sp,color: Colors.black)),
          SizedBox(width: 10,),
          message?ClipRRect(
            borderRadius: BorderRadius.circular(9.0),
            child: Container(
              alignment: Alignment.center,
              width: 10,
              height: 20,
              color: ThemeColor.ColorSale(),
            ),
          ):SizedBox()
        ],
      ),
    );
  }



}

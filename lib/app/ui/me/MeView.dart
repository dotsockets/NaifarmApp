import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/BuildIconShop.dart';

import 'myshop/MyshopView.dart';
import 'purchase/PurchaseView.dart';


class MeView extends StatefulWidget {
  @override
  _MeViewState createState() => _MeViewState();
}

class _MeViewState extends State<MeView> with SingleTickerProviderStateMixin{

  bool IsLogin = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     setState(() {
       ISLogin();
     });

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
                margin: EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.settings,
                  color: Colors.white,size: 30
                ),
              ),
              actions: [
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 13,top: 5),
                    child:
                    BuildIconShop(size: 30,)
                  ),
                  onTap: (){
                    AppRoute.MyCart(context);
                  },
                ),

              ],
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: ThemeColor.primaryColor(),
                  child: IsLogin?Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          width: 80,
                          height: 80,
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
                      SizedBox(height: 15),
                      Text("วีระชัย ใจกว้าง",
                          style: GoogleFonts.sarabun(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))
                    ],
                  ):_FormLogin(),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                  height: 700,
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
                                isScrollable: false,
                                tabs: [
                                  _tabbar(title: "การซื้อ",message: false),
                                  _tabbar(title: "ร้านค้าของฉัน",message: false)
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
    return Container(
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
            //  AppRoute.ImageProduct(context);
            },
            child: Text("เข้าสู่ระบบ",
              style: GoogleFonts.sarabun(fontSize: 20,fontWeight: FontWeight.w500),
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
            child: Text("สมัครสมาชิก",
              style: GoogleFonts.sarabun(fontSize: 20,fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }


  Widget _tabbar({String title,bool message}){
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,style: GoogleFonts.sarabun(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.black)),
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

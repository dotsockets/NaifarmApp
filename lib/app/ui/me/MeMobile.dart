import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/ui/myshop/MyshopView.dart';
import 'package:naifarm/app/ui/purchase/PurchaseView.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/widgets/AppToobar.dart';

class MeMobile extends StatefulWidget {
  @override
  _MeMobileState createState() => _MeMobileState();
}

class _MeMobileState extends State<MeMobile> with SingleTickerProviderStateMixin{

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
                    margin: EdgeInsets.only(right: 15),
                    child:
                        Icon(Icons.shopping_cart_outlined, color: Colors.white,size: 30,),
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
                  child: Column(
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
                  ),
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
                                PurchaseView(),
                                MyshopView()
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


  Widget _tabbar({String title,bool message}){
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,style: GoogleFonts.kanit()),
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

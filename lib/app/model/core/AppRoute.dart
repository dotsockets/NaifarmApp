import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/ui/flashsale/FlashSaleView.dart';
import 'package:naifarm/app/ui/home/HomeView.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:naifarm/app/ui/login/SplashLoginView.dart';
import 'package:naifarm/app/ui/market/MarketView.dart';
import 'package:naifarm/app/ui/me/deliveryCost/DeliveryCostView.dart';
import 'package:naifarm/app/ui/me/editmyproduct/EditProductView.dart';
import 'package:naifarm/app/ui/me/imageproduct/ImageProductView.dart';
import 'package:naifarm/app/ui/me/mynewproduct/MyNewProductView.dart';
import 'package:naifarm/app/ui/me/myproduct/MyProductView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/MyShophiStoryView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/review/ReviewView.dart';
import 'package:naifarm/app/ui/me/myshop/withdrawmoney/WithdrawMoneyView.dart';
import 'package:naifarm/app/ui/me/myshop/withdrawmoney/moneyout/MoneyOutView.dart';
import 'package:naifarm/app/ui/me/payment/PaymentView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/mycart/cartaddress/CartAaddressView.dart';
import 'package:naifarm/app/ui/mycart/cartbank/CartBankView.dart';
import 'package:naifarm/app/ui/me/delivery/DeliveryView.dart';
import 'package:naifarm/app/ui/mycart/cartsummary/CartSummaryView.dart';
import 'package:naifarm/app/ui/mylike/MyLikeView.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiDetailView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/order/OrderView.dart';
import 'package:naifarm/app/ui/product_detail/ProductDetailView.dart';
import 'package:naifarm/app/ui/register/RegisterOTPView.dart';
import 'package:naifarm/app/ui/register/RegisterView.dart';
import 'package:naifarm/app/ui/register/Register_FBView.dart';
import 'package:naifarm/app/ui/register/Register_Name_OtpView.dart';
import 'package:naifarm/app/ui/register/Register_set_PasswordView.dart';
import 'package:naifarm/app/ui/setting/about/AboutView.dart';
import 'package:naifarm/app/ui/setting/address/AddressView.dart';
import 'package:naifarm/app/ui/setting/addressAdd/AddressAddView.dart';
import 'package:naifarm/app/ui/setting/bank/BankSettingView.dart';
import 'package:naifarm/app/ui/setting/bankadd/BankAddView.dart';
import 'package:naifarm/app/ui/setting/creditcardadd/CreditAddView.dart';
import 'package:naifarm/app/ui/setting/help/HelpView.dart';
import 'package:naifarm/app/ui/setting/language/LanguageSettingView.dart';
import 'package:naifarm/app/ui/setting/noti/NotiSettingView.dart';
import 'package:naifarm/app/ui/setting/policy/PolicyView.dart';
import 'package:naifarm/app/ui/setting/profile/SettingProfileView.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/EditProfileVIew.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/Setting_EditProdile_BioView.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/Setting_EditProfile_NameView.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editemail/EditEmail_Step1View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editemail/EditEmail_Step2View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editemail/EditEmail_Step3View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editpassword/EditpasswordStep1View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editpassword/EditpasswordStep2View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editphone/EditPhone_Step1View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editphone/EditPhone_Step2View.dart';
import 'package:naifarm/app/ui/setting/rulesOfUse/RuleOfUseView.dart';
import 'package:naifarm/app/ui/shopmain/ShopMainView.dart';
import 'package:naifarm/app/ui/shopmain/followers/FollowersView.dart';
import 'package:naifarm/app/ui/specialproducts/SpecialproductsView.dart';
import 'package:page_transition/page_transition.dart';

class AppRoute{
  // static  home(BuildContext context){
  //   Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: HomeView()));
  // }

  static ProductDetail(BuildContext context,{String productImage}){
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ProductDetailView(productImage: productImage)));
  }
  static  Market(BuildContext context){
  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MarketView()));
  }
  static  Specialproducts(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: SpecialproductsView()));
  }
  static  FlashSaleAll(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: FlashSaleView()));
  }

  static  MyCart(BuildContext context,bool BtnBack){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyCartView(BtnBack: BtnBack,)));
  }


  static  MyNoti(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiView()));
  }

  static  NotiDetail(BuildContext context,String notiImage,String notiTitle){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiDetailView(notiImage: notiImage,notiTitle: notiTitle,)));
  }

  static  MyLike(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyLikeView()));
  }
  static  OrderDetail(BuildContext context,int  Status_Sell){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: OrderView( Status_Sell: Status_Sell)));
  }

  static  CartSummary(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartSummaryView()));
  }

  static  CartAaddres(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartAaddressView()));
  }

  static  CartBank(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartBankView()));
  }

  static DeliveryMe(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: DeliveryView()));
  }
  static PaymentMe(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: PaymentView()));
  }
  static MyProduct(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView()));
  }
  static MyNewProduct(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyNewProductView()));
  }


  static ShopMain(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ShopMainView()));
  }


  static Followers(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: FollowersView()));
  }

  static DeliveryCost(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: DeliveryCostView()));
  }

  static EditProduct(BuildContext context,int index){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: EditProductView(index: index,)));
  }

  static ImageProduct(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ImageProductView()));
  }

  static WithdrawMoney(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: WithdrawMoneyView()));
  }

  static MyShophistory(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyShophistoryView()));
  }


  static Review(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ReviewView()));
  }

  static MoneyOut(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MoneyOutView()));
  }

  static Register(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: RegisterView()));
  }

  static SplashLogin(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashLoginView()), (Route<dynamic> route) => false);
  }

  static Home(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeView()), (Route<dynamic> route) => false);
  }

  static Login(BuildContext context,{bool IsCallBack}){

    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: LoginView(IsCallBack: IsCallBack,)));
  }

  static SettingHelp(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: HelpView()));
  }

  static SettingRules(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: RulesOfUseView()));
  }

  static SettingPolicy(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: PolicyView()));
  }
  static SettingProfile(BuildContext context,String languageTxt){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: SettingProfileView(languageTxt:languageTxt)));
  }
  static SettingAbout(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: AboutView()));
  }
  static SettingAddress(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: AddressView()));
  }
  static SettingAddAddress(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: AddressAddView()));
  }

  static RegisterOTP(BuildContext context,  {String phoneNumber}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: RegisterOTPView(phoneNumber: phoneNumber,)));
  }
  static Register_set_Password(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_set_PasswordView()));
  }

  static Register_Name_Otp(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_Name_OtpView()));
  }

  static Register_FB(BuildContext context,String email){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_FBView(email: email,)));
  }
  static SettingLanguage(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: LanguageSettingView()));
  }
  static SettingBank(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: BankSettingView()));
  }
  static SettingNoti(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiSettingView()));
  }

  static EditProfile(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: EditProfileVIew()));
  }

  static Setting_EditProfile_Name(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Setting_EditProfile_NameView()));
  }

  static Setting_EditProdile_Bio(BuildContext context){

    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Setting_EditProdile_BioView()));
  }
  static EditPhoneStep1(BuildContext context) {
    Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditPhone_Step1View()));
  }
  static EditPhoneStep2(BuildContext context,String PhoneNew) {
    Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditPhone_Step2View(PhoneNew: PhoneNew,)));
  }
  static SettingBankAdd(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: BankAddView()));
  }
  static SettingCreditAdd(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CreditAddView()));

  }
  static EditEmail_Step1(BuildContext context) {
    Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditEmail_Step1View()));
  }
  static EditEmail_Step2(BuildContext context) {
    Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditEmail_Step2View()));
  }
  static EditEmail_Step3(BuildContext context,String email) {
    Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditEmail_Step3View(email: email,)));
  }

  static EditpasswordStep1(BuildContext context) {
    Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditpasswordStep1View()));

  }

  static EditpasswordStep2(BuildContext context) {
    Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditpasswordStep2View()));
  }
}







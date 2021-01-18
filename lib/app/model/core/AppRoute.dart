import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CarriersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/models/ProductModel.dart';
import 'package:naifarm/app/ui/Shopmynear/ShopMyNearView.dart';
import 'package:naifarm/app/ui/category/detail/CategoryDetailView.dart';
import 'package:naifarm/app/ui/category/detail/CategorySubDetailView.dart';
import 'package:naifarm/app/ui/flashsale/FlashSaleView.dart';
import 'package:naifarm/app/ui/home/HomeView.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:naifarm/app/ui/login/SplashLoginView.dart';
import 'package:naifarm/app/ui/market/MarketView.dart';
import 'package:naifarm/app/ui/me/delivery/DeliveryEditView.dart';
import 'package:naifarm/app/ui/me/deliveryCost/DeliveryCostView.dart';
import 'package:naifarm/app/ui/me/editmyproduct/EditProductView.dart';
import 'package:naifarm/app/ui/me/imageproduct/ImageProductView.dart';
import 'package:naifarm/app/ui/me/mynewproduct/MyNewProductView.dart';
import 'package:naifarm/app/ui/me/myproduct/MyProductView.dart';
import 'package:naifarm/app/ui/me/myproductaddtype/ProductAddTypeView.dart';
import 'package:naifarm/app/ui/me/myproductsetprice/ProductSetPriceView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/MyShophiStoryView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/review/ReviewView.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/EditDetailView.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/EditExtrlUrlView.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/EditProviceView.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/EditSlugView.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/ShopProfileView.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/EditNameShopView.dart';
import 'package:naifarm/app/ui/me/myshop/shopprofile/OfficialNameView.dart';
import 'package:naifarm/app/ui/me/myshop/withdrawmoney/WithdrawMoneyView.dart';
import 'package:naifarm/app/ui/me/myshop/withdrawmoney/moneyout/MoneyOutView.dart';
import 'package:naifarm/app/ui/me/payment/PaymentView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/mycart/cartaddress/CartAaddressView.dart';
import 'package:naifarm/app/ui/mycart/cartbank/CartBankView.dart';
import 'package:naifarm/app/ui/me/delivery/DeliveryView.dart';
import 'package:naifarm/app/ui/mycart/cartsummary/CartSummaryView.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiDetailView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/order/OrderView.dart';
import 'package:naifarm/app/ui/productdetail/ProductDetailView.dart';
import 'package:naifarm/app/ui/productmore/ProductMoreView.dart';
import 'package:naifarm/app/ui/register/ForgotPasswordView.dart';
import 'package:naifarm/app/ui/register/RegisterOTPView.dart';
import 'package:naifarm/app/ui/register/RegisterView.dart';
import 'package:naifarm/app/ui/register/Register_FBView.dart';
import 'package:naifarm/app/ui/register/Register_Name_OtpView.dart';
import 'package:naifarm/app/ui/register/Register_set_PasswordView.dart';
import 'package:naifarm/app/ui/search/SearchView.dart';
import 'package:naifarm/app/ui/setting/about/AboutView.dart';
import 'package:naifarm/app/ui/setting/address/AddressView.dart';
import 'package:naifarm/app/ui/setting/addressAdd/AddressAddView.dart';
import 'package:naifarm/app/ui/setting/addressEdit/AddressEditView.dart';
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
import 'package:naifarm/app/ui/shopmynear/searchmap/SearchMapView.dart';
import 'package:naifarm/app/ui/splash/ConnectErrorView.dart';
import 'package:naifarm/app/ui/splash/SplashView.dart';
import 'package:naifarm/app/ui/wishlist/WishlistsView.dart';
import 'package:page_transition/page_transition.dart';

class AppRoute{
  // static  home(BuildContext context){
  //   Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: HomeView()));
  // }

  static ProductDetail(BuildContext context,{String productImage,ProducItemRespone productItem}){
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ProductDetailView(productImage: productImage,productItem: productItem,)));
  }
  static  Market(BuildContext context){
  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MarketView()));
  }

  static  FlashSaleAll(BuildContext context,{FlashsaleRespone instalData}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.rightToLeft, child: FlashSaleView(instalData: instalData,)));
  }

  static  MyCart(BuildContext context,bool btnBack){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyCartView(btnBack: btnBack,)));
  }


  static  MyNoti(BuildContext context,bool btnBack){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiView(btnBack:btnBack)));
  }

  static  NotiDetail(BuildContext context,String notiImage,String notiTitle){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiDetailView(notiImage: notiImage,notiTitle: notiTitle,)));
  }

  static  OrderDetail(BuildContext context,int  Status_Sell){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: OrderView( Status_Sell: Status_Sell)));
  }

  static  CartSummary(BuildContext context,CartResponse item){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartSummaryView(item:item)));
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
  static MyProduct(BuildContext context,{bool pushEvent=false}){
    if(pushEvent){
      Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView()));
    }else{
      Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView()));
    }

  }
  static MyNewProduct(BuildContext context,{IsActive IsActive}){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyNewProductView(isActive: IsActive,)));
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

  static MyShophistory(BuildContext context,int index){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyShophistoryView(index: index)));
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

  static Home(BuildContext context, {HomeObjectCombine item}){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeView()), (Route<dynamic> route) => false);
  }

  static Future<bool>  Login(BuildContext context,{bool IsCallBack,  HomeObjectCombine item}) async {

    return await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: LoginView(IsCallBack: IsCallBack,item: item,)));
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
  static Future<bool> SettingProfile(BuildContext context,bool IsLogin,{CustomerInfoRespone item}) async {
    return await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: SettingProfileView(IsLogin:IsLogin,item: item)));
  }
  static SettingAbout(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: AboutView()));
  }
  static SettingAddress(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: AddressView()));
  }

  static Future<bool> SettingAddAddress(BuildContext context) async {
    return  await Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child:AddressAddView()));
  }

  static RegisterOTP(BuildContext context,  {String phoneNumber,String refCode}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: RegisterOTPView(phoneNumber: phoneNumber,refCode: refCode)));
  }
  static Register_set_Password(BuildContext context,String phone){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_set_PasswordView(phone: phone)));
  }

  static Register_Name_Otp(BuildContext context,String phone,String password){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_Name_OtpView(phone: phone,password: password)));
  }

  static Register_FB(BuildContext context,String email){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_FBView(email: email,)));
  }
  static SettingLanguage(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: LanguageSettingView()));
  }
  static SettingLanguageToHome(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeView()), (Route<dynamic> route) => false);
  }
  static SettingBank(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: BankSettingView()));
  }
  static SettingNoti(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiSettingView()));
  }

  static Future<bool> EditProfile(BuildContext context,{ CustomerInfoRespone item}) async {
    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: EditProfileVIew(item: item,)));
  }

  static Future<CustomerInfoRespone> Setting_EditProfile_Name(BuildContext context,CustomerInfoRespone customerInfoRespone) async {
    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Setting_EditProfile_NameView(customerInfoRespone: customerInfoRespone,)));
  }

  static Future<CustomerInfoRespone> Setting_EditProdile_Bio(BuildContext context,CustomerInfoRespone customerInfoRespone) async {
    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Setting_EditProdile_BioView(customerInfoRespone: customerInfoRespone,)));
  }
  static  Future<CustomerInfoRespone>  EditPhoneStep1(BuildContext context,CustomerInfoRespone customerInfoRespone) async {
    return  await   Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditPhone_Step1View(customerInfoRespone: customerInfoRespone)));
  }
  static Future<CustomerInfoRespone> EditPhoneStep2(BuildContext context,CustomerInfoRespone customerInfoRespone,String PhoneNew) async {
    return  await  Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditPhone_Step2View(PhoneNew: PhoneNew,customerInfoRespone: customerInfoRespone,)));
  }
  static SettingBankAdd(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: BankAddView()));
  }
  static SettingCreditAdd(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CreditAddView()));

  }
  static Future<CustomerInfoRespone> EditEmail_Step1(BuildContext context,CustomerInfoRespone customerInfoRespone) async {
    return  await  Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditEmail_Step1View(customerInfoRespone: customerInfoRespone,)));
  }
  static Future<CustomerInfoRespone>  EditEmail_Step2(BuildContext context,CustomerInfoRespone customerInfoRespone) async {
    return  await  Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditEmail_Step2View(customerInfoRespone: customerInfoRespone,)));
  }
  static Future<CustomerInfoRespone> EditEmail_Step3(BuildContext context,String emailnew,CustomerInfoRespone customerInfoRespone) async {
    return  await Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditEmail_Step3View(emailnew: emailnew,customerInfoRespone: customerInfoRespone,)));
  }

  static EditpasswordStep1(BuildContext context) {
    Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditpasswordStep1View()));

  }

  static EditpasswordStep2(BuildContext context,String passwordOld) {
    Navigator.pushReplacement(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: EditpasswordStep2View(passwordOld: passwordOld,)));
  }
  static CategoryDetail(BuildContext context,int index,{String title}){
    Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: CategoryDetailView(index: index,title: title,)));
  }
  static CategorySubDetail(BuildContext context,int index,{String title}){
    Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child: CategorySubDetailView(index: index,title: title,)));
  }
  static ShopMyNear(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ShopMyNearView()));
  }
  static SearchHome(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: SearchView()));
  }
  static SearchMap(BuildContext context,String locationTxt){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: SearchMapView(locationTxt: locationTxt,)));
  }
  static ProductAddType(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ProductAddTypeView()));
  }

  static ProductSetPrice(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ProductSetPriceView()));
  }
  static ForgotPassword(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ForgotPasswordView()));
  }
  static ProductMore({BuildContext context,String barTxt,ProductRespone installData,String api_link}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ProductMoreView(barTxt:barTxt,installData: installData,api_link: api_link,)));
  }

  static Future<bool> AddressEdit(BuildContext context,AddressesData item) async {
    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:AddressEditView(item: item,)));
  }

  static Future<bool>  ShopProfile(BuildContext context) async {
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ShopProfileView()));
  }

  static Future<MyShopRespone>  EditNameShop(BuildContext context,{MyShopRespone itemInfo}) async {
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:EditNameShopView(itemInfo: itemInfo,)));
  }

  static Future<MyShopRespone>  OfficialName(BuildContext context,{MyShopRespone itemInfo}) async {
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:OfficialNameView(itemInfo: itemInfo,)));
  }

  static Future<MyShopRespone>  EditSlug(BuildContext context,{MyShopRespone itemInfo}) async {
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:EditSlugView(itemInfo: itemInfo,)));
  }

  static Future<MyShopRespone>  EditDetail(BuildContext context,{MyShopRespone itemInfo}) async {
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:EditDetailView(itemInfo: itemInfo,)));
  }

  static Future<MyShopRespone>  EditExtrlUrl(BuildContext context,{MyShopRespone itemInfo}) async {
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:EditExtrlUrlView(itemInfo: itemInfo,)));
  }

  static Future<MyShopRespone>  EditProvice(BuildContext context,{MyShopRespone itemInfo}) async {
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:EditProviceView(itemInfo: itemInfo,)));
  }

  static Future<bool> DeliveryEdit(BuildContext context,{ShppingMyShopRespone shppingMyShopRespone,CarriersData carriersDat}) async {
    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:DeliveryEditView(shppingMyShopRespone: shppingMyShopRespone,carriersData: carriersDat,)));
  }

  static Wishlists({BuildContext context}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:WishlistsView()));
  }

  static ConnectError({BuildContext context,String text_error}){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ConnectErrorView(text_error: text_error,)));
  }

  static Splash({BuildContext context}){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:SplashView()));
  }
}










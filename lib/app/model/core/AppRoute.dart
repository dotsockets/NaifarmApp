import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CarriersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/app/ui/Shopmynear/ShopMyNearView.dart';
import 'package:naifarm/app/ui/category/detail/CategoryDetailView.dart';
import 'package:naifarm/app/ui/category/detail/CategorySubDetailView.dart';
import 'package:naifarm/app/ui/flashsale/FlashSaleDetail.dart';
import 'package:naifarm/app/ui/home/HomeView.dart';
import 'package:naifarm/app/ui/login/LoginView.dart';
import 'package:naifarm/app/ui/login/SplashLoginView.dart';
import 'package:naifarm/app/ui/market/MarketView.dart';
import 'package:naifarm/app/ui/me/delivery/DeliveryEditView.dart';
import 'package:naifarm/app/ui/me/delivery/DeliverySelectView.dart';
import 'package:naifarm/app/ui/me/deliveryCost/DeliveryCostView.dart';
import 'package:naifarm/app/ui/me/editmyproduct/EditImageProductView.dart';
import 'package:naifarm/app/ui/me/editmyproduct/EditProductView.dart';
import 'package:naifarm/app/ui/me/imageproduct/ImageProductView.dart';
import 'package:naifarm/app/ui/me/mynewproduct/MyNewProductView.dart';
import 'package:naifarm/app/ui/me/mynewproduct/SearchMyProduct.dart';
import 'package:naifarm/app/ui/me/myproduct/MyProductView.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/AttributeEditView.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/AttributeView.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/detail/AttributeDetailEditView.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/detail/AttributeDetailView.dart';
import 'package:naifarm/app/ui/me/myproduct/productDetailShop/ProductDetailShop.dart';
import 'package:naifarm/app/ui/me/myproductaddtype/ProductAddTypeView.dart';
import 'package:naifarm/app/ui/me/myproductsetprice/ProductSetPriceView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/ConfirmPaymentView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/DeliveryDropoffView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/MyOrderHistoryView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/ShippingOrderView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/ShopOrderHistoryView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/review/ReviewView.dart';
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
import 'package:naifarm/app/ui/me/payment/TransferPayMent.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/mycart/cart/OrderSuccessView.dart';
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
import 'package:naifarm/app/ui/register/Forgot_set_NewPasswordView.dart';
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
import 'package:naifarm/app/ui/setting/profile/editprofile/editpassword/EditpasswordStep1View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editpassword/EditpasswordStep2View.dart';
import 'package:naifarm/app/ui/setting/profile/editprofile/editphone/EditPhone_Step1View.dart';
import 'package:naifarm/app/ui/setting/rulesOfUse/RuleOfUseView.dart';
import 'package:naifarm/app/ui/shopmain/ShopMainView.dart';
import 'package:naifarm/app/ui/shopmain/followers/FollowersView.dart';
import 'package:naifarm/app/ui/shopmynear/searchmap/SearchMapView.dart';
import 'package:naifarm/app/ui/splash/ConnectErrorView.dart';
import 'package:naifarm/app/ui/splash/SplashView.dart';
import 'package:naifarm/app/ui/wishlist/WishlistsView.dart';
import 'package:naifarm/utility/widgets/ImageFullScreen.dart';
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
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: FlashSaleView(instalData: instalData,)));
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

  static  OrderDetail(BuildContext context,{OrderData orderData,String orderType}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: OrderView(orderData: orderData,orderType: orderType,)));
  }

  static  CartSummary(BuildContext context,CartResponse item){


    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartSummaryView(item:item)));
  }

  static Future<AddressesListRespone>  CartAaddres(BuildContext context,{AddressesData install_select}) async {
    return await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartAaddressView(install_select: install_select,)));
  }

  static Future<PaymentRespone>  CartBank(BuildContext context,{PaymentRespone paymentRespone}) async {
    return await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartBankView(paymentRespone: paymentRespone,)));
  }

  static DeliveryMe(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: DeliveryView()));
  }
  static PaymentMe(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: PaymentView()));
  }
  static MyProduct(BuildContext context,int shopId,{bool pushEvent=false,int countPage=1,int indexTab=0}){
    if(pushEvent){
    //  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView()));
    // Navigator.pop(context);
      PoppageCount(context: context,countpage: countPage);
      Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView(shopId:shopId,indexTab: indexTab,)));
      // Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView(shopId:shopId)));
    }else{
      Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView(shopId:shopId,indexTab: indexTab,)));
    }

  }
  static ProductDetailShop(BuildContext context,{String productImage,ProductMyShop productItem}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ProductDetailShopView(productImage: productImage,productItem: productItem,)));
  }
  static MyNewProduct(BuildContext context,int shopId,{IsActive isActive}){

    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyNewProductView(shopId: shopId,)));
  }


  static ShopMain({BuildContext context,MyShopRespone myShopRespone}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ShopMainView(myShopRespone: myShopRespone,)));
  }


  static Followers(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: FollowersView()));
  }

  static Future<int>  DeliveryCost(BuildContext context,{UploadProductStorage uploadProductStorage,int productsId}) async {
    return await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: DeliveryCostView(uploadProductStorage: uploadProductStorage,productsId: productsId,)));
  }

  static Future<bool> EditProduct(BuildContext context,int index,int shopId,{UploadProductStorage uploadProductStorage,int indexTab=0}) async {
    return await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: EditProductView(indexTab:indexTab,ProductId: index,uploadProductStorage: uploadProductStorage,shopId: shopId,)));
  }

  static Future<bool> ImageProduct(BuildContext context,{IsActive isactive})async{
    if(isactive== IsActive.ReplacemenView){

      return await  Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ImageProductView(isActive: isactive,)));
    }else{
      return await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ImageProductView(isActive: isactive,)));
    }
  }

  static WithdrawMoney(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: WithdrawMoneyView()));
  }

  static MyShophistory(BuildContext context,int index,{bool callback=false}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyOrderHistoryView(index: index,callback: callback,)));

  }

  static ShopOrderHistory(BuildContext context,int index,{bool callback=false}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ShopOrderHistoryView(index: index,callback: callback,)));

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

  static Home(BuildContext context, ){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeView()), (Route<dynamic> route) => route.isFirst);

  }

  static Future<bool>  Login(BuildContext context,{bool IsCallBack,Function(bool) homeCallBack,bool IsHeader}) async {

    return await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: LoginView(IsCallBack: IsCallBack,homeCallBack: homeCallBack,IsHeader: IsHeader,)));
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
    return  await Navigator.push(context, PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.fade,
        child:AddressAddView()));
  }

  static RegisterOTP(BuildContext context,  {String phoneNumber,String refCode, RequestOtp requestOtp}){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: RegisterOTPView(requestOtp: requestOtp,phoneNumber: phoneNumber,refCode: refCode)));
  }
  static Register_set_Password(BuildContext context,String phone){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_set_PasswordView(phone: phone)));
  }

  static Forgot_set_NewPassword(BuildContext context,{String phone,String code,String ref}){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Forgot_set_NewPasswordView(phone: phone,code: code,ref: ref,)));
  }


  static Register_Name_Otp(BuildContext context,String phone,String password){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: Register_Name_OtpView(phone: phone,password: password)));
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

  static Future<bool> EditProfile(BuildContext context) async {
    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: EditProfileVIew()));
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
  static ProductMore({BuildContext context,String barTxt,ProductRespone installData,String api_link,int type_more}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ProductMoreView(type_more: type_more,barTxt:barTxt,installData: installData,api_link: api_link)));
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

  static ConnectError({BuildContext context,Result result,bool show_full,Function callback}){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ConnectErrorView(result: result,show_full: show_full,callback: callback,)));
  }

  static Splash({BuildContext context}){
    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:SplashView()));
  }

  static Future<bool>  EditImageProduct({BuildContext context,UploadProductStorage uploadProductStorage,int ProductId})async{
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:EditImageProductView(ProductId: ProductId,uploadProductStorage: uploadProductStorage,)));
  }

  static Future<ShippingRates>  DeliverySelect({BuildContext context,int shopId,int select_id})async{
    return  await  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:DeliverySelectView(shopId: shopId,select_id: select_id,)));
  }

  static OrderSuccess({BuildContext context,String payment_total,OrderData orderData}){

    Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:OrderSuccessView(payment_total: payment_total,orderData: orderData,)));
  }

  static PoppageCount({BuildContext context,int countpage,bool callback}){
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == countpage;
    });
  }

  static SearchMyProductView({BuildContext context,int shopID}){
  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:SearchMyProduct(shopID:shopID,)));
  }

  static Attribute({BuildContext context}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:AttributeView()));
  }

  static AttributeDetail({BuildContext context,int idAttr}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:AttributeDetailView(idAttr:idAttr)));
  }
  static AttributeEdit({BuildContext context,String nameAttr,int idAttr}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:AttributeEditView(nameAttr:nameAttr,idAttr:idAttr)));
  }

  static AttributeDetailEdit({BuildContext context,String value,int idAttr,String color,int vid}){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:AttributeDetailEditView(idAttr:idAttr,value:value,color:color,vid:vid)));
  }

  static ImageFullScreenView({BuildContext context,String image,String hero_tag}){

    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ImageFullScreen(image: image,hero_tag: hero_tag,)));

  }

  static TransferPayMentView({BuildContext context,OrderData orderData}){

    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:TransferPayMent(orderData: orderData,)));

  }

  static Future<bool>  ConfirmPayment({BuildContext context,OrderData orderData}) async {

    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ConfirmPaymentView(orderData: orderData,)));

  }

  static Future<bool>  ShippingOrder({BuildContext context,OrderData orderData}) async {

    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:ShippingOrderView(orderData: orderData,)));

  }

  static Future<bool>  DeliveryDropoff({BuildContext context}) async {

    return  await Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child:DeliveryDropoffView()));

  }



}











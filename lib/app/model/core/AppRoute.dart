import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/bloc/Stream/UploadProductBloc.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CarriersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
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
import 'package:naifarm/app/ui/me/myproduct/MyProductView.dart';
import 'package:naifarm/app/ui/me/myproduct/SearchMyProduct.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/AttributeEditView.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/AttributeView.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/detail/AttributeDetailEditView.dart';
import 'package:naifarm/app/ui/me/myproduct/attribute/detail/AttributeDetailView.dart';
import 'package:naifarm/app/ui/me/myproduct/productDetailShop/ProductDetailShop.dart';
import 'package:naifarm/app/ui/me/myproductaddtype/ProductAddTypeView.dart';
import 'package:naifarm/app/ui/me/myproductsetprice/ProductSetPriceView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/AddtTrackingNumberView.dart';
import 'package:naifarm/app/ui/me/myshop/myorderhistory/SellerCanceledView.dart';
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
import 'package:naifarm/app/ui/order/OrderCancleView.dart';
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
import 'package:naifarm/app/ui/setting/guestSetting/SettingGuestView.dart';
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

class AppRoute {
  // static  home(BuildContext context){
  //   Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.rightToLeftWithFade, child: HomeView()));
  // }

  static Future<bool> productDetail(BuildContext context,
      {String productImage, ProducItemRespone productItem}) async {
    return await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            child: ProductDetailView(
              productImage: productImage,
              productItem: productItem,
            )));
  }

  static market(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: MarketView()));
  }

  static flashSaleAll(BuildContext context,
      {FlashsaleRespone flashsaleRespone}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: FlashSaleView(
              flashsaleRespone: flashsaleRespone,
            )));
  }

  static myCart(BuildContext context, bool btnBack,
      {List<ProductData> cartNowId}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: MyCartView(
              btnBack: btnBack,
              cartNowId: cartNowId,
            )));
  }

  static myNoti(BuildContext context, bool btnBack) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: NotiView(btnBack: btnBack)));
  }

  static notiDetail(BuildContext context, String notiImage, String notiTitle) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: NotiDetailView(
              notiImage: notiImage,
              notiTitle: notiTitle,
            )));
  }

  static Future<bool> orderDetail(BuildContext context,
      {OrderData orderData, OrderViewType typeView}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: OrderView(
              orderData: orderData,
              typeView: typeView,
            )));
  }

  static cartSummary(BuildContext context, CartResponse item) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: CartSummaryView(item: item)));
  }

  static Future<AddressesListRespone> cartAddres(BuildContext context,
      {AddressesData installSelect}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: CartAaddressView(
              installSelect: installSelect,
            )));
  }

  static Future<PaymentRespone> cartBank(BuildContext context,
      {PaymentRespone paymentRespone, String AllShopID}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: CartBankView(
              paymentRespone: paymentRespone,
              AllShopID: AllShopID,
            )));
  }

  static deliveryMe(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: DeliveryView()));
  }

  static paymentMe(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: PaymentView()));
  }

  static myProduct(BuildContext context, int shopId,
      {bool pushEvent = false, int countPage = 1, int indexTab = 0}) {
    if (pushEvent) {
      //  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.rightToLeftWithFade, child: MyProductView()));
      // Navigator.pop(context);
      poppageCount(context: context, countpage: countPage);
      Navigator.push(
          context,
          PageTransition(
              duration: Duration(milliseconds: 300),
              type: PageTransitionType.rightToLeftWithFade,
              child: MyProductView(
                shopId: shopId,
                indexTab: indexTab,
              )));
      // Navigator.pushReplacement(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.rightToLeftWithFade, child: MyProductView(shopId:shopId)));
    } else {
      Navigator.push(
          context,
          PageTransition(
              duration: Duration(milliseconds: 300),
              type: PageTransitionType.rightToLeftWithFade,
              child: MyProductView(
                shopId: shopId,
                indexTab: indexTab,
              )));
    }
  }

  static productDetailShop(BuildContext context,
      {String productImage, ProductMyShop productItem}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ProductDetailShopView(
              productImage: productImage,
              productItem: productItem,
            )));
  }

  static myNewProduct(BuildContext context, int shopId, {IsActive isActive}) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: MyNewProductView(
              shopId: shopId,
            )));
  }

  static shopMain({BuildContext context, MyShopRespone myShopRespone}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ShopMainView(
              myShopRespone: myShopRespone,
            )));
  }

  static followers(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: FollowersView()));
  }

  static Future<double> deliveryCost(BuildContext context,
      {UploadProductStorage uploadProductStorage, int productsId}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: DeliveryCostView(
              uploadProductStorage: uploadProductStorage,
              productsId: productsId,
            )));
  }

  static Future<bool> editProduct(BuildContext context, int index, int shopId,
      {UploadProductStorage uploadProductStorage, int indexTab = 0}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditProductView(
              indexTab: indexTab,
              productId: index,
              uploadProductStorage: uploadProductStorage,
              shopId: shopId,
            )));
  }

  static Future<bool> imageProduct(BuildContext context,
      {IsActive isactive}) async {
    if (isactive == IsActive.ReplacemenView) {
      return await Navigator.pushReplacement(
          context,
          PageTransition(
              duration: Duration(milliseconds: 300),
              type: PageTransitionType.rightToLeftWithFade,
              child: ImageProductView(
                isActive: isactive,
              )));
    } else {
      return await Navigator.push(
          context,
          PageTransition(
              duration: Duration(milliseconds: 300),
              type: PageTransitionType.rightToLeftWithFade,
              child: ImageProductView(
                isActive: isactive,
              )));
    }
  }

  static withdrawMoney(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: WithdrawMoneyView()));
  }

  static myShophistory(BuildContext context, int index,
      {bool callback = false}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: MyOrderHistoryView(
              index: index,
              callback: callback,
            )));
  }

  static shopOrderHistory(BuildContext context, int index,
      {bool callback = false}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ShopOrderHistoryView(
              index: index,
              callback: callback,
            )));
  }

  static review(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ReviewView()));
  }

  static moneyOut(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: MoneyOutView()));
  }

  static register(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: RegisterView()));
  }

  static splashLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashLoginView()),
        (Route<dynamic> route) => false);
  }

  static home(
    BuildContext context,
  ) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeView()),
        (Route<dynamic> route) => route.isFirst);
  }

  static Future<bool> login(BuildContext context,
      {bool isCallBack, Function(bool) homeCallBack, bool isHeader,bool isSetting}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: LoginView(
              isCallBack: isCallBack,
              homeCallBack: homeCallBack,
              isHeader: isHeader,
              isSetting: isSetting,
            )));
  }

  static settingHelp(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: HelpView()));
  }

  static settingRules(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: RulesOfUseView()));
  }

  static settingPolicy(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: PolicyView()));
  }

  static Future<bool> settingProfile(BuildContext context) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SettingProfileView()));
  }

  static settingAbout(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AboutView()));
  }

  static settingAddress(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AddressView()));
  }

  static Future<bool> settingAddAddress(BuildContext context) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AddressAddView()));
  }

  static registerOTP(BuildContext context,
      {String phoneNumber, String refCode, RequestOtp requestOtp}) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: RegisterOTPView(
                requestOtp: requestOtp,
                phoneNumber: phoneNumber,
                refCode: refCode)));
  }

  static registerSetPassword(
      BuildContext context, String phone, String name, String email) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: RegisterSetPasswordView(
              phone: phone,
              name: name,
              email: email,
            )));
  }

  static forgotSetNewPassword(BuildContext context,
      {String phone, String code, String ref}) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ForgotSetNewPasswordView(
              phone: phone,
              code: code,
              ref: ref,
            )));
  }

  static registerNameOtp(BuildContext context, String phone, String password) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: RegisterNameOtpView(phone: phone, password: password)));
  }

  static registerFB(BuildContext context, String email) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: RegisterFBView(
              email: email,
            )));
  }

  static settingLanguage(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: LanguageSettingView()));
  }

  static settingLanguageToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeView()),
        (Route<dynamic> route) => false);
  }

  static settingBank(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: BankSettingView()));
  }

  static settingNoti(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: NotiSettingView()));
  }

  static Future<bool> editProfile(BuildContext context) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditProfileVIew()));
  }

  static Future<CustomerInfoRespone> settingEditProfileName(
      BuildContext context, CustomerInfoRespone customerInfoRespone) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SettingEditProfileNameView(
              customerInfoRespone: customerInfoRespone,
            )));
  }

  static Future<CustomerInfoRespone> settingEditProdileBio(
      BuildContext context, CustomerInfoRespone customerInfoRespone) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SettingEditProdileBioView(
              customerInfoRespone: customerInfoRespone,
            )));
  }

  static Future<CustomerInfoRespone> editPhoneStep1(
      BuildContext context, CustomerInfoRespone customerInfoRespone) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child:
                EditPhoneStep1View(customerInfoRespone: customerInfoRespone)));
  }

  static settingBankAdd(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: BankAddView()));
  }

  static settingCreditAdd(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: CreditAddView()));
  }

  static Future<CustomerInfoRespone> editEmailStep1(
      BuildContext context, CustomerInfoRespone customerInfoRespone) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditEmailStep1View(
              customerInfoRespone: customerInfoRespone,
            )));
  }

  static Future<CustomerInfoRespone> editEmailStep2(
      BuildContext context, CustomerInfoRespone customerInfoRespone) async {
    return await Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditEmailStep2View(
              customerInfoRespone: customerInfoRespone,
            )));
  }

  static editpasswordStep1(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditpasswordStep1View()));
  }

  static editpasswordStep2(BuildContext context, String passwordOld) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditpasswordStep2View(
              passwordOld: passwordOld,
            )));
  }

  static categoryDetail(BuildContext context, int index, {String title}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: CategoryDetailView(
              index: index,
              title: title,
            )));
  }

  static categorySubDetail(BuildContext context, int index, {String title}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: CategorySubDetailView(
              index: index,
              title: title,
            )));
  }

  static shopMyNear(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ShopMyNearView()));
  }

  static searchHome(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SearchView()));
  }

  static searchMap(BuildContext context, String locationTxt) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SearchMapView(
              locationTxt: locationTxt,
            )));
  }

  static productAddType(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ProductAddTypeView()));
  }

  static productSetPrice(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ProductSetPriceView()));
  }

  static forgotPassword(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ForgotPasswordView()));
  }

  static productMore(
      {BuildContext context,
      String barTxt,
      ProductRespone installData,
      String apiLink,
      int typeMore}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ProductMoreView(
                typeMore: typeMore,
                barTxt: barTxt,
                installData: installData,
                apiLink: apiLink)));
  }

  static Future<bool> addressEdit(
      BuildContext context, AddressesData item) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AddressEditView(
              item: item,
            )));
  }

  static Future<bool> shopProfile(BuildContext context) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ShopProfileView()));
  }

  static Future<MyShopRespone> editNameShop(BuildContext context,
      {MyShopRespone itemInfo}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditNameShopView(
              itemInfo: itemInfo,
            )));
  }

  static Future<MyShopRespone> officialName(BuildContext context,
      {MyShopRespone itemInfo}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: OfficialNameView(
              itemInfo: itemInfo,
            )));
  }

  static Future<MyShopRespone> editSlug(BuildContext context,
      {MyShopRespone itemInfo}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditSlugView(
              itemInfo: itemInfo,
            )));
  }

  static Future<MyShopRespone> editDetail(BuildContext context,
      {MyShopRespone itemInfo}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditDetailView(
              itemInfo: itemInfo,
            )));
  }

  static Future<MyShopRespone> editExtrlUrl(BuildContext context,
      {MyShopRespone itemInfo}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditExtrlUrlView(
              itemInfo: itemInfo,
            )));
  }

  static Future<MyShopRespone> editProvice(BuildContext context,
      {MyShopRespone itemInfo}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditProviceView(
              itemInfo: itemInfo,
            )));
  }

  static Future<bool> deliveryEdit(BuildContext context,
      {ShppingMyShopRespone shppingMyShopRespone,
      CarriersData carriersDat}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: DeliveryEditView(
              shppingMyShopRespone: shppingMyShopRespone,
              carriersData: carriersDat,
            )));
  }

  static wishlists({BuildContext context}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: WishlistsView()));
  }

  static connectError(
      {BuildContext context,
      ThrowIfNoSuccess result,
      bool showFull,
      Function callback}) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ConnectErrorView(
              result: result,
              showFull: showFull,
              callback: callback,
            )));
  }

  static splash({BuildContext context}) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SplashView()));
  }

  static Future<bool> editImageProduct(
      {BuildContext context,
      UploadProductStorage uploadProductStorage,
      int productId}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: EditImageProductView(
              productId: productId,
              uploadProductStorage: uploadProductStorage,
            )));
  }

  static Future<ShippingRates> deliverySelect(
      {BuildContext context, int shopId, int selectId}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: DeliverySelectView(
              shopId: shopId,
              selectId: selectId,
            )));
  }

  static orderSuccess(
      {BuildContext context, String paymentTotal, OrderData orderData}) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: OrderSuccessView(
              paymentTotal: paymentTotal,
              orderData: orderData,
            )));
  }

  static poppageCount({BuildContext context, int countpage, bool callback}) {
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == countpage;
    });
  }

  static searchMyProductView({BuildContext context, int shopID, int tabNum}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SearchMyProduct(
              shopID: shopID,
              tabNum: tabNum,
            )));
  }

  static attribute({BuildContext context}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AttributeView()));
  }

  static attributeDetail({BuildContext context, int idAttr}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AttributeDetailView(idAttr: idAttr)));
  }

  static attributeEdit({BuildContext context, String nameAttr, int idAttr}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AttributeEditView(nameAttr: nameAttr, idAttr: idAttr)));
  }

  static attributeDetailEdit(
      {BuildContext context, String value, int idAttr, String color, int vid}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AttributeDetailEditView(
                idAttr: idAttr, value: value, color: color, vid: vid)));
  }

  static imageFullScreenView(
      {BuildContext context, String image, String heroTag}) {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ImageFullScreen(
              image: image,
              heroTag: heroTag,
            )));
  }

  static Future<bool> transferPayMentView(
      {BuildContext context, OrderData orderData}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: TransferPayMent(
              orderData: orderData,
            )));
  }

  static Future<bool> confirmPayment(
      {BuildContext context, OrderData orderData}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ConfirmPaymentView(
              orderData: orderData,
              contextMain: context,
            )));
  }

  static Future<bool> shippingOrder(
      {BuildContext context, OrderData orderData}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: ShippingOrderView(
              orderData: orderData,
            )));
  }

  static Future<bool> deliveryDropoff({BuildContext context}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: DeliveryDropoffView()));
  }

  static Future<bool> sellerCanceled(
      {BuildContext context,
      OrderData orderData,
      OrderViewType typeView}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: SellerCanceledView(
              orderData: orderData,
              typeView: typeView,
            )));
  }

  static Future<bool> addtTrackingNumber(
      {BuildContext context, OrderData orderData}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: AddtTrackingNumberView(orderData: orderData)));
  }

  static Future<bool> orderCancle(
      {BuildContext context, OrderData orderData}) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            child: OrderCancleView(orderData: orderData)));
  }

  static Future<bool> settingGuest(BuildContext context) async {
    return await Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.fade,
            child: SettingGuestView()));
  }
}

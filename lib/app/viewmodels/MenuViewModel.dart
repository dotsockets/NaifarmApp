import 'package:naifarm/app/models/MenuModel.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class MenuViewModel {
  List<MenuModel> getTabBarMenus() {
    return [
      MenuModel(
        icon: 'assets/images/svg/home_active.svg',
        iconSelected: 'assets/images/svg/home_active.svg',
        label: LocaleKeys.tab_bar_recommend.tr(),
      ),
      MenuModel(
        icon: 'assets/images/svg/type.svg',
        iconSelected: 'assets/images/svg/type.svg',
        label: LocaleKeys.tab_bar_category.tr(),
      ),
      MenuModel(
        icon: 'assets/images/svg/cart.svg',
        iconSelected: 'assets/images/svg/cart.svg',
        label: LocaleKeys.tab_bar_cart.tr(),
      ),
      MenuModel(
        icon: 'assets/images/svg/me.svg',
        iconSelected: 'assets/images/svg/me.svg',
        label: LocaleKeys.tab_bar_me.tr(),
      )
    ];
  }

  List<MenuModel> getMenustype() {
    return [
      MenuModel(
        type: 1,
        icon: '',
        iconSelected: '',
        label: "แนะนำ",
      ),
      MenuModel(
        type: 2,
        icon:
            'https://i.pinimg.com/474x/23/62/82/236282008edd75a537efb8e2466523fc.jpg',
        iconSelected: '',
        label: "พืช",
      ),
      MenuModel(
        type: 3,
        icon: 'https://fbi.dek-d.com/27/0562/0008/121605209',
        iconSelected: '',
        label: "ไร่",
      ),
      MenuModel(
        type: 4,
        icon:
            'https://www.img.in.th/images/ca547d3ced18180cf606c9e7efd4d795.jpg',
        iconSelected: '',
        label: "ปศุสัตว์",
      ),
      MenuModel(
        type: 5,
        icon: 'https://cf.shopee.co.th/file/c8153734422a141d410e1f3a3a7c8ae6',
        iconSelected: '',
        label: "ไม้เศรษฐกิจ",
      ),
      MenuModel(
        type: 6,
        icon: 'https://www.chaipat.or.th/images/Media/rice-1594612_960_720.jpg',
        iconSelected: '',
        label: "ข้าว",
      ),
      MenuModel(
        type: 7,
        icon:
            'https://www.kasetkaoklai.com/home/wp-content/uploads/2019/08/136251.jpg',
        iconSelected: '',
        label: "ประมง",
      ),
      MenuModel(
        type: 8,
        icon:
            'https://obs.line-scdn.net/0hNNWq9Dm-EWFqCD74AgFuNlBeEg5ZZAJiDj5AYjZmT1VPbwIwUmoKD0kKH1VPb1Y_BGZXA0cIClBBOgY-BGsK/w644',
        iconSelected: '',
        label: "เนื้อสัตว์",
      ),
      MenuModel(
        type: 9,
        icon: 'https://dd.lnwfile.com/_/dd/_raw/ie/pe/k7.jpg',
        iconSelected: '',
        label: "ปุ๋ยและยา",
      ),
      MenuModel(
        type: 10,
        icon:
            'https://ktw.co.th/content/images/thumbs/0364748_hsd1g-80c-รื่รนิน-สร์ทมื-new_300.jpeg',
        iconSelected: '',
        label: "เครื่องมือ",
      )
    ];
  }

  List<MenuModel> getMenusVegetable() {
    return [
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "แนะนำ",
      ),
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "ผักบุ้ง",
      ),
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "พริก",
      ),
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "คะน้า",
      ),
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "แตงกวา",
      ),
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "มะขาม",
      ),
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "ผักกาด",
      ),
    ];
  }

  List<MenuModel> getRecommendmenu() {
    return [
      MenuModel(
          icon: 'assets/images/svg/menu_near.svg',
          iconSelected: 'assets/images/svg/menu_near.svg',
          label: LocaleKeys.recommend_near_me.tr(),
          page: "ShopMyNear"),
      MenuModel(
          icon: 'assets/images/svg/menu_market.svg',
          iconSelected: 'assets/images/svg/menu_market.svg',
          label: LocaleKeys.recommend_market.tr(),
          page: "MarketView"),
      MenuModel(
          icon: 'assets/images/svg/menu_spacial_price.svg',
          iconSelected: 'assets/images/svg/menu_spacial_price.svg',
          label: LocaleKeys.recommend_special_price.tr(),
          page: "SpecialproductsView"),
      MenuModel(
          icon: 'assets/images/svg/menu_noti.svg',
          iconSelected: 'assets/images/svg/menu_noti.svg',
          label: LocaleKeys.recommend_notification.tr(),
          page: "NotiView"),
      MenuModel(
          icon: 'assets/images/svg/menu_like.svg',
          iconSelected: 'assets/images/svg/menu_like.svg',
          label: LocaleKeys.my_product_like.tr(),
          page: "MyLikeView")
    ];
  }
}

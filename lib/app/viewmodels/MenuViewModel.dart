

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/models/MenuModel.dart';

class MenuViewModel {
  List<MenuModel> getTabBarMenus() {
    return [
      MenuModel(
        icon: 'assets/images/svg/home_active.svg',
        iconSelected: 'assets/images/svg/home_active.svg',
        label: "แนะนำ",
      ),
      MenuModel(
        icon: 'assets/images/svg/type.svg',
        iconSelected: 'assets/images/svg/type.svg',
        label: "ประเภท",
      ),
      MenuModel(
        icon: 'assets/images/svg/cart.svg',
        iconSelected: 'assets/images/svg/cart.svg',
        label: "ตะกร้า",
      ),
      MenuModel(
        icon: 'assets/images/svg/me.svg',
        iconSelected: 'assets/images/svg/me.svg',
        label: "ฉัน",
      )
    ];
  }

  List<MenuModel> getMenustype() {
    return [
      MenuModel(
        icon: '',
        iconSelected: '',
        label: "แนะนำ",
      ),
      MenuModel(
        icon: 'https://i.pinimg.com/474x/23/62/82/236282008edd75a537efb8e2466523fc.jpg',
        iconSelected: '',
        label: "พืช",
      ),
      MenuModel(
        icon: 'https://fbi.dek-d.com/27/0562/0008/121605209',
        iconSelected: '',
        label: "ไร่",
      ),
      MenuModel(
        icon: 'https://lh3.googleusercontent.com/proxy/yTmlRBjkOvcTk_G8nIGL4K-cLje0zlZsAjGJtQKfgq0SB4llXJOgBxyNe759tQ511Z80UpHjFFWJDHv3jza088h_JHjbPqXhNqbzeODRfGwWrWxH3TAKprJk_MIuyA',
        iconSelected: '',
        label: "ปศุสัตว์",
      ),
      MenuModel(
        icon: 'https://cf.shopee.co.th/file/c8153734422a141d410e1f3a3a7c8ae6',
        iconSelected: '',
        label: "ไม้เศรษฐกิจ",
      ),

      MenuModel(
        icon: 'https://www.chaipat.or.th/images/Media/rice-1594612_960_720.jpg',
        iconSelected: '',
        label: "ข้าว",
      ),
      MenuModel(
        icon: 'https://ktw.co.th/content/images/thumbs/0364748_hsd1g-80c-รื่รนิน-สร์ทมื-new_300.jpeg',
        iconSelected: '',
        label: "เครื่องมือเกษตร",
      ),
      MenuModel(
        icon: 'https://www.kasetkaoklai.com/home/wp-content/uploads/2019/08/136251.jpg',
        iconSelected: '',
        label: "ประมง",
      ),
      MenuModel(
        icon: 'https://obs.line-scdn.net/0hNNWq9Dm-EWFqCD74AgFuNlBeEg5ZZAJiDj5AYjZmT1VPbwIwUmoKD0kKH1VPb1Y_BGZXA0cIClBBOgY-BGsK/w644',
        iconSelected: '',
        label: "เนื้อสัตว์",
      ),
      MenuModel(
        icon: 'https://dd.lnwfile.com/_/dd/_raw/ie/pe/k7.jpg',
        iconSelected: '',
        label: "ปุ๋ยและยา",
      )
    ];
  }

  List<MenuModel> getRecommendmenu(){
    return [
      MenuModel(
        icon: 'assets/images/svg/menu_near.svg',
        iconSelected: 'assets/images/svg/menu_near.svg',
        label: "ใกล้ฉัน",
      ),
      MenuModel(
        icon: 'assets/images/svg/menu_market.svg',
        iconSelected: 'assets/images/svg/menu_market.svg',
        label: "ฟาร์มมาร์เก็ต",
      ),
      MenuModel(
        icon: 'assets/images/svg/menu_spacial_price.svg',
        iconSelected: 'assets/images/svg/menu_spacial_price.svg',
        label: "ราคาพิเศษ",
      ),
      MenuModel(
        icon: 'assets/images/svg/menu_noti.svg',
        iconSelected: 'assets/images/svg/menu_noti.svg',
        label: "แจ้งเตือน",
      ),
      MenuModel(
        icon: 'assets/images/svg/menu_like.svg',
        iconSelected: 'assets/images/svg/menu_like.svg',
        label: "ถูกใจ",
      )
    ];
  }




}
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/NotificationOneSignal.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/config/Env.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneSignalCall {
  final BuildContext context;

  OneSignalCall(this.context);

  static Future<void> initializeOneSignal() async {
    //Remove this method to stop OneSignal Debugging

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(Env.value.onesignal, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      if (status.subscriptionStatus.subscribed) {
        // String onesignalUserId = status.subscriptionStatus.userId;
        print('Player ID: ' + status.subscriptionStatus.pushToken);
      }
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  static oneSignalReceivedHandler(BuildContext context) async {
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) async {
     // print("wefcerf ${notification.payload.rawPayload['custom']['a']}");

      Usermanager().getUser().then((value) => context.read<CustomerCountBloc>()
          .loadCustomerCount(context, token: value.token));
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      var item = NotificationOneSignal.fromJson(
          jsonDecode(result.notification.payload.rawPayload['custom']));

      if (item.item.type == "Shop") {
        AppRoute.orderDetail(context,
            orderData: OrderData(id: int.parse(item.item.id)),
            typeView: OrderViewType.Shop);
      } else if (item.item.type == "Customer") {
        AppRoute.orderDetail(context,
            orderData: OrderData(id: int.parse(item.item.id)),
            typeView: OrderViewType.Purchase);
      }
    });
  }

  static Future selectNotification(String payload) async {
    if (payload != null) {
      //debugPrint('notification payload: $payload');
    }
  }

  static Future cancelNotification(String slag, int ref,
      {String orderNumber}) async {
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();
    notificationsPlugin.cancelAll();
    // NaiFarmLocalStorage.getOneSiganlCache().then((data) {
    //   if (data != null) {
    //     for (var value in data.onesignal) {
    //       if (value.slagView == slag && value.refID == ref) {
    //         notificationsPlugin.cancel(value.androidNotificationId.toInt());
    //       }
    //     }
    //   }
    // });
  }
}

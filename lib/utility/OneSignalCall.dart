import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/config/Env.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneSignalCall {
  final BuildContext context;
  OneSignalCall(this.context);

  static Future<void> initializeOneSignal() async {
    //Remove this method to stop OneSignal Debugging

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared
        .setAppId(Env.value.onesignal);



    OneSignal.shared.consentGranted(true);
    OneSignal.shared.clearOneSignalNotifications();

    OneSignal.shared.setRequiresUserPrivacyConsent(true);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });



    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) async {

    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  static oneSignalOpenedHandler(BuildContext context) async {

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      Usermanager().getUser().then((value) => context.read<CustomerCountBloc>()
          .loadCustomerCount(context, token: value.token));
      var item = NotificationOneSignal.fromJson(
          jsonDecode(result.notification.jsonRepresentation().replaceAll("\\n", "\n")));

      if (item.custom.a.type == "Shop") {
        AppRoute.orderDetail(context,
            orderData: OrderData(id: int.parse(item.custom.a.id)),
            typeView: OrderViewType.Shop);
      } else if (item.custom.a.type == "Customer") {
        AppRoute.orderDetail(context,
            orderData: OrderData(id: int.parse(item.custom.a.id)),
            typeView: OrderViewType.Purchase);
      }
    });

  }

    static oneSignalReceivedHandler(BuildContext context) async {


    OneSignal.shared
        .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');
      /// Display Notification, send null to not display

      print("Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      event.complete(null);

      Usermanager().getUser().then((value) => context.read<CustomerCountBloc>()
          .loadCustomerCount(context, token: value.token));
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

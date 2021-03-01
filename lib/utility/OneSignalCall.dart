
import 'package:naifarm/config/Env.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalCall{
  static Future<void> InitializeOneSignal() async {
    //Remove this method to stop OneSignal Debugging

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(
       Env.value.onesignal,
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        }
    );
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);



// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);



    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      var status = await OneSignal.shared.getPermissionSubscriptionState();
      if (status.subscriptionStatus.subscribed){
        String onesignalUserId = status.subscriptionStatus.userId;
        print('Player ID: ' + status.subscriptionStatus.pushToken);
      }
    });

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
      // will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });


  }

  static OneSignalReceivedHandler() async {
    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) async {
      print("notification : ${notification}");


    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
    });
  }


  static Future selectNotification(String payload) async {
    if (payload != null) {
      //debugPrint('notification payload: $payload');
    }

  }
}
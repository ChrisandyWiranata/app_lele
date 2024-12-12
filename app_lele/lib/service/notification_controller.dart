import 'package:app_lele/screen/home/chat.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NotificationController extends ChangeNotifier {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  String _firebaseToken = '';
  String get firebaseToken => _firebaseToken;

  String _nativeToken = '';
  String get nativeToken => _nativeToken;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelKey: 'notif_message_channel',
            channelName: 'Message notifications',
            channelDescription: 'Notification channel for messages',
            defaultColor: const Color(0xFF9D58D0),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            playSound: true,
            enableVibration: true,
            channelShowBadge: true),
      ],
    );
  }

  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        final token = await AwesomeNotificationsFcm().requestFirebaseAppToken();
        debugPrint('Firebase token: $token');
        return token;
      } catch (exception) {
        debugPrint('Failed to get Firebase token: $exception');
      }
    }
    return '';
  }

  static Future<void> refreshToken() async {
    String token = await requestFirebaseToken();
    if (token.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fcmToken': token});
      }
    }
  }

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        licenseKeys: null,
        debug: debug);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    debugPrint('Silent data received: ${silentData.toString()}');
    await executeLongTaskInBackground();
  }

  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    debugPrint('FCM Token: $token');
    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }

  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    debugPrint('Native Token: $token');
    _instance._nativeToken = token;
    _instance.notifyListeners();
  }

  static Future<void> executeLongTaskInBackground() async {
    debugPrint("Starting background task");
    await Future.delayed(const Duration(seconds: 4));
    debugPrint("Background task completed");
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.channelKey == 'notif_message_channel' &&
        receivedAction.payload?['receiverUid'] ==
            FirebaseAuth.instance.currentUser?.uid) {
      final senderData = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: receivedAction.payload?['senderUid'])
          .get();

      if (senderData.docs.isNotEmpty) {
        final userDoc = senderData.docs.first;
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              currentUserUid: FirebaseAuth.instance.currentUser!.uid,
              selectedUser: userDoc,
            ),
          ),
        );
      }
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification dismissed');
  }
}

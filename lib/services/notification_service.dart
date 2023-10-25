import 'dart:convert';

import 'package:etravel_mobile/models/notification_data.dart';
import 'package:etravel_mobile/services/callkit_service.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:uuid/uuid.dart';

import '../repository/conversation_repository.dart';
import '../view/conversation/chat_view.dart';
import '../view/conversation/video_call_view.dart';
import 'local_storage_service.dart';

var uuid = const Uuid();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  get initializationSettings => const InitializationSettings(
          android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ));

  Future<void> initialize(
    Function(NotificationResponse) onDidReceiveNotificationResponse,
  ) async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  List<AndroidNotificationAction>? _getNotificationActions(
      int? notificationType) {
    switch (notificationType) {
      case 1: // Send request
        return [
          const AndroidNotificationAction(
            'accept',
            'Accept',
          ),
          const AndroidNotificationAction(
            'reject',
            'Reject',
          ),
        ];
      default:
        return null;
    }
  }

  Future<bool> _ensurePermissionsGranted() async {
    final isGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    return isGranted ?? false;
  }

  void _showNotification(RemoteMessage message) async {
    final showNotificationGranted = await _ensurePermissionsGranted();
    if (!showNotificationGranted) {
      return;
    }
    final notificationData = NotificationData.fromJson(message.data);
    final NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'etravel_notification',
        'eTravel Notification',
        channelDescription: 'eTravel Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        actions: _getNotificationActions(
          notificationData.type,
        ),
      ),
    );
    flutterLocalNotificationsPlugin.show(
      message.messageId.hashCode,
      message.notification!.title,
      message.notification!.body,
      details,
      payload: json.encode(message.data),
    );
  }

  void _onContactRequestNotificationData(
    ContactRequestNotificationData notificationData,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final accountSender = await LocalStorageService.getInstance.getAccount();
    if (accountSender == null) {
      return;
    }
    await ConversationRepository().postConversation({
      'accountOneId': accountSender.id,
      'accountTwoId': notificationData.senderId,
    });

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (ctx) => ChatView(
          sender: chat_types.User(
            id: accountSender.id.toString(),
            metadata: {
              'phone': accountSender.phone,
            },
            firstName: accountSender.firstName,
            lastName: accountSender.lastName,
            imageUrl: accountSender.image,
          ),
          receiver: chat_types.User(
            id: notificationData.senderId.toString(),
            metadata: {
              'phone': notificationData.senderPhone,
            },
            firstName: notificationData.senderFirstName,
            lastName: notificationData.senderLastName,
            imageUrl: notificationData.senderImage,
          ),
        ),
      ),
    );
  }

  void _onCallNotificationData(
    CallNotificationData notificationData,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final accountSender = await LocalStorageService.getInstance.getAccount();
    if (accountSender == null) {
      return;
    }

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (ctx) => VideoCallView(
          localUid: accountSender.id!,
          autoJoinCall: false,
          isJoinedThroughNotification: true,
          token: notificationData.callingToken,
          channelName: notificationData.channelId,
          remoteUid: int.parse(
            notificationData.remoteUid,
          ),
        ),
      ),
    );
  }

  Future<void> onDidReceiveNotificationResponse(
      GlobalKey<NavigatorState> navigatorKey,
      NotificationResponse response) async {
    loggerInfo.i('onDidReceiveNotificationResponse');
    final decodedPayload = json.decode(response.payload!);
    final notificationData = NotificationData.fromJson(decodedPayload);

    switch (notificationData.type) {
      case NotificationTypes.contactRequest:
        final notificationData =
            ContactRequestNotificationData.fromJson(decodedPayload);
        _onContactRequestNotificationData(notificationData, navigatorKey);
        break;
      case NotificationTypes.call:
        final notificationData = CallNotificationData.fromJson(decodedPayload);
        _onCallNotificationData(notificationData, navigatorKey);
      default:
        break;
    }
  }

  void handleFirebaseNotification(RemoteMessage message) {
    final notificationBasicData = NotificationData.fromJson(message.data);
    switch (notificationBasicData.type) {
      case NotificationTypes.call:
        final callNotificationData =
            CallNotificationData.fromJson(message.data);
        CallkitService().receiveCall(callNotificationData);
        break;
      default:
        break;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
class NotificationClass {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var initializationSettings;

  NotificationClass._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
  }

  // setOnNotificationClick(Function onNotificationClick) async {
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: (String payload) async {
  //     onNotificationClick(payload);
  //   });
  // }

  Future<void> showNotification(String body) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    var androidChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var platformChannelSpecifics =
        NotificationDetails(android: androidChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Test Title', body, platformChannelSpecifics,
        payload: 'Test Payload');
  }
}

NotificationClass notificationPlugin = NotificationClass._();
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluter_prjcts/Models/game_data.dart';
import "package:fluter_prjcts/Router/router.dart";

void receiveNotificationsInit() {
  //setupForeground();
  setupOpenedApp();
  setupBackGround();
  setupTerminatedApp();
}

void setupForeground() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      final gameDataMap = jsonDecode(message.data["gameData"]);
      final gameData = GameData.fromMap(gameDataMap);

      router.push("/join-game", extra: gameData);
    }
  });
}

void setupOpenedApp() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      final gameDataMap = jsonDecode(message.data["gameData"]);
      final gameData = GameData.fromMap(gameDataMap);

      router.push("/join-game", extra: gameData);
    }
  });
}

void setupBackGround() {
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
}

@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    final gameDataMap = jsonDecode(message.data["gameData"]);
    final gameData = GameData.fromMap(gameDataMap);
    router.push("/join-game", extra: gameData);
  }
}

void setupTerminatedApp() {
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null && message.notification != null) {
      final gameDataMap = jsonDecode(message.data["gameData"]);
      final gameData = GameData.fromMap(gameDataMap);
      router.push("/join-game", extra: gameData);
    }
  });
}
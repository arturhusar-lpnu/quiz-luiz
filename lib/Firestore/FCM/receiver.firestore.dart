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
    print("Foreground message received");
    if (message.notification != null) {
      final gameData = GameData.fromMap(message.data);

      router.push("/join-game", extra: gameData);
    }
  });
}

void setupOpenedApp() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Opened App message received");
    if (message.notification != null) {
      final gameData = GameData.fromMap(message.data);

      router.push("/join-game", extra: gameData);
    }
  });
}

void setupBackGround() {
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print("Background message received");
  if (message.notification != null) {
    final gameData = GameData.fromMap(message.data);
    router.push("/join-game", extra: gameData);
  }
}

void setupTerminatedApp() {
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null && message.notification != null) {
      final gameData = GameData.fromMap(message.data);

      router.push("/join-game", extra: gameData);
    }
  });
}
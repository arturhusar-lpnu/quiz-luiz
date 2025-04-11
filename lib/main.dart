import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluter_prjcts/firebase_options.dart';
import 'package:flutter/material.dart';
import './Router/router.dart';
import "package:fluter_prjcts/Widgets/PopUp/error.popup.dart";
import "package:fluter_prjcts/Firestore/FCM/receiver.firestore.dart";

import 'Firestore/FCM/notification.service.dart';

void main() async{
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // //FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    //   String? userId = FirebaseAuth.instance.currentUser?.uid;
    //   if (userId != null) {
    //     await FirebaseFirestore.instance.collection('players').doc(userId).update({
    //       'fcmToken': newToken,
    //     });
    //   }
    // });

    FlutterError.onError = (FlutterErrorDetails details) {
      _showGlobalError(details.exceptionAsString());
    };

    //receiveNotificationsInit();
    await NotificationService.instance.initialize();

    runApp(MyApp());
  }, (error, _) {
    _showGlobalError(error.toString());
  });
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

void _showGlobalError(String message) {
  final context = _rootNavigatorKey.currentContext;
  if (context != null) {
    showErrorDialog(
      context: context,
      title: "Whoops!",
      message: message,
      icon: Icons.error_outline, // Icons.cloud_off for connection
      onRetry: () {
        if(router.canPop()) {
          router.pop();
        } else {
          router.go("/");
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData.dark(),
      // home: HomeScreen(),
    );
  }
}

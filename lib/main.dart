import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluter_prjcts/Blocs/RecentTopicsBloc/recent_topics_bloc.dart';
import 'package:fluter_prjcts/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluter_prjcts/Router/router.dart';
import "package:fluter_prjcts/Widgets/PopUp/error.popup.dart";

import 'Blocs/TopicBloc/topic_bloc.dart';
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

    final firestore = FirebaseFirestore.instance;

    runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TopicBloc(firestore: firestore),
            ),
            BlocProvider(
              create: (context) => RecentTopicsBloc(firestore: firestore),
            ),
            // BlocProvider(
            //   create: (context) => QuestionBloc(firestore: firestore),
            // ),
            // BlocProvider(
            //   create: (context) => AnswersBloc(firestore: firestore),
            // ),
          ],
          child: MyApp()
      ),
    );
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
    );
  }
}

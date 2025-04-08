import 'package:firebase_core/firebase_core.dart';
import 'package:fluter_prjcts/firebase_options.dart';
import 'package:flutter/material.dart';
import './Router/router.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        "Oops! ${details.exception}",
        style: const TextStyle(color: Colors.red),
      ),
    );
  };
  runApp(MyApp());
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

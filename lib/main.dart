import 'package:firebase_core/firebase_core.dart';
import 'package:fluter_prjcts/firebase_options.dart';
import 'package:flutter/material.dart';
import './Router/router.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

// class HomeScreen extends StatelessWidget {
//
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF2C2C3C),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Color(0xFF9B73D8),
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white60,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.games), label: "Games"),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   "QuizLuiz",
//                   style: TextStyle(fontSize: 24, color: Colors.amber, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 16),
//               _buildSection("New Game", [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildButton("Spectate", Colors.purple),
//                     _buildButton("Create", Colors.green),
//                   ],
//                 ),
//               ]),
//               _buildSection("Practice", [
//                 _buildGameCard("Match with AI", Colors.green, "Start"),
//                 _buildGameCard("Rerun Mistakes", Colors.purple, "Start"),
//               ]),
//               _buildSection("Match History", [
//                 _buildMatchHistory("Win", Colors.green, "Friendly", "AC/DC"),
//                 _buildMatchHistory("Loss", Colors.red, "Ranked", "Math"),
//               ]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSection(String title, List<Widget> children) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(fontSize: 18, color: Colors.amber, fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButton(String text, Color color) {
//     return Expanded(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: color),
//           onPressed: () {},
//           child: Text(text),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGameCard(String title, Color color, String buttonText) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
//           Text("Type: Random", style: TextStyle(color: Colors.white70)),
//           Text("Topic: Random", style: TextStyle(color: Colors.white70)),
//           Align(
//             alignment: Alignment.centerRight,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: color),
//               onPressed: () {},
//               child: Text(buttonText),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMatchHistory(String result, Color color, String type, String topic) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(backgroundColor: color, radius: 10),
//           SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
//               Text("Type: $type", style: TextStyle(color: Colors.white70)),
//               Text("Topic: $topic", style: TextStyle(color: Colors.white70)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

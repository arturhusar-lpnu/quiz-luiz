import 'package:fluter_prjcts/Router/router.dart';
import 'package:fluter_prjcts/Screens/topics.screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'games_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';

enum ScreensEnum {
  homeScreen,
  gamesScreen,
  topicScreen,
  statsScreen,
  profileScreen,
}


class MainScreen extends StatefulWidget {
  final int index;
  const MainScreen({super.key, required this.index});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    GamesScreen(),
    TopicsScreen(),
    StatsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      switch(ScreensEnum.values[index]) {
        case ScreensEnum.homeScreen:
          router.go('/');
          break;
        case ScreensEnum.gamesScreen :
          router.go('/games');
          break;
        case ScreensEnum.topicScreen:
          router.go('/topics');
          break;
        case ScreensEnum.statsScreen :
          router.go('/stats');
          break;
        case ScreensEnum.profileScreen :
          router.go('/profile');
          break;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Color(0xFFA27BFA),
        onTap: _onItemTapped,
          iconSize: 28,
        items: [
          BottomNavigationBarItem(icon : Icon(Icons.home, size: 32), label: 'Home'),
          BottomNavigationBarItem(icon : Icon(Icons.videogame_asset, size: 32), label: 'Games'),
          BottomNavigationBarItem(icon : Icon(Icons.library_add_rounded, size: 32), label: 'Topics'),
          BottomNavigationBarItem(icon : Icon(Icons.bar_chart, size: 32), label: 'Stats'),
          BottomNavigationBarItem(icon : Icon(Icons.person, size: 32), label: 'Profile'),
        ],
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        unselectedItemColor: Color(0xFF30323d),
        unselectedLabelStyle: TextStyle(color: Color(0xFF30323d), fontSize: 14),

      ),
    );
  }
}
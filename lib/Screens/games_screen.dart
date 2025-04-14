import 'package:fluter_prjcts/Widgets/Other/practice_mode.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Widgets/Other/screen_title.dart';
import 'package:fluter_prjcts/Widgets/Other/new_game_modes.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Scaffold with SafeArea to ensure proper display
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  ScreenTitle(title: "QuizLuiz"),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Tab Controller section - this needs to be in Expanded to work properly
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4d5061),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 18,
                        ),
                        indicator: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            )
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(text: 'Solo Mode'),
                          Tab(text: 'Multiplayer'),
                        ],
                      ),
                    ),

                    // Tab Bar View
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4d5061),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: TabBarView(
                          children: [
                            /// TAB 1: Solo mode
                            SoloMode(),
                            /// TAB 2: Multiplayer
                            NewGameModes(),
                          ],
                        ),
                      ),
                    ),

                    // Add padding at the bottom
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
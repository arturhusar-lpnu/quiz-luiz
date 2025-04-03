import 'dart:collection';

import 'package:fluter_prjcts/Actions/Buttons/back_button.dart';
import 'package:fluter_prjcts/Widgets/Other/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import '../Pages/GameSetup/final_setup_page.dart';
import '../Pages/GameSetup/game_mode_page.dart';
import '../Pages/GameSetup/game_topics_page.dart';
import '../Pages/GameSetup/game_type_page.dart';
import '../Pages/GameSetup/opponent_page.dart';

enum GameConfigChoices { gameType, gameMode, gameTopics, gameOpponent, config }

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  _GameSetupScreenState createState() => _GameSetupScreenState();
}

class _GameSetupScreenState  extends State<GameSetupScreen>{
  final PageController _pageController = PageController();
  int _currentPage = 0;

  GameType? selectedGameType;
  GameMode? selectedGameMode;
  Set<String> selectedTopicsIds = HashSet();
  String selectedOpponentId = "";

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child:
                Row(
                  children: [
                    ReturnBackButton(
                        backColor: Colors.amber,
                        iconColor: Colors.black,
                        radius: 20),
                    SizedBox(width: 40),
                    ScreenTitle(title: "Game Setup")
                  ],
                )
            ),

            SizedBox(height: 20),

            // Progress Dots at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: () {
                      if (index == _currentPage && _currentPage == 4) {
                        // Apply the green color to the last dot (index 4)
                        return Color(0xFF8BFFD6);
                      } else {
                        // For other dots, use white with alpha depending on the current page
                        return index == _currentPage
                            ? Colors.white
                            : Colors.white.withAlpha(30);
                      }
                    } (),
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            // Main content - PageView that changes with swipes and Next/Previous buttons
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(), // Disable swiping - use buttons only
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  GameTypePage(
                    selectedGameType: selectedGameType,
                    onGameTypeSelected: (GameType gameType) {
                      setState(() {
                        selectedGameType = gameType;
                      });
                    },
                  ),
                  GameModePage(
                    selectedMode: selectedGameMode,
                    onModeSelected: (GameMode gameMode) {
                      setState(() {
                        selectedGameMode = gameMode;
                      });
                    },
                  ),
                  GameTopicsPage(
                    selectedTopics: selectedTopicsIds,
                    onTopicSelected: (topicId) {
                      setState(() {
                        if (selectedTopicsIds.contains(topicId)) {
                          selectedTopicsIds.remove(topicId);
                        } else {
                          selectedTopicsIds.add(topicId);
                        }
                      });
                    },
                  ),
                  OpponentPage( //TODO Invite User on Create
                    selectedOpponentId: selectedOpponentId,
                    userId: "0",
                    onSelectedOpponent: (opponentID) {
                      setState(() {
                        if(opponentID.isNotEmpty) {
                          selectedOpponentId = opponentID;
                        }
                      });
                    },
                  ),
                  FinalSetupPage(
                    selectedGameMode: selectedGameMode,
                    selectedGameType: selectedGameType,
                    selectedOpponentId: selectedOpponentId,
                    selectedTopicsIds: selectedTopicsIds,
                    currentUserId: "curr-user-id",
                  ),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: _currentPage > 0 ? goToPreviousPage : null,
                    child: Text('Previous'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      // Check if current page is complete before proceeding
                      bool canProceed = false;
                      switch (_currentPage) {
                        case 0:
                          canProceed = selectedGameType != null;
                          break;
                        case 1:
                          canProceed = selectedGameMode != null;
                          break;
                        case 2:
                          canProceed = selectedTopicsIds.isNotEmpty;
                          break;
                        case 3:
                          canProceed = selectedOpponentId != null;
                          break;
                        case 4:
                        // Final setup page - create and start the game
                          canProceed = true;
                          break;
                      }

                      if (canProceed) {
                        if (_currentPage < 4) {
                          goToNextPage();
                        } else {
                          // TODO Game setup is complete, start the game
                          //_startGame();
                        }
                      } else {
                        // Show message to complete current selection
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please make a selection to continue')),
                        );
                      }
                    },
                    child: Text(_currentPage == 4 ? 'Start Game' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      )

    );
  }
}
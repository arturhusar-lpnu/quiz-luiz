import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/Enums/game_type.enum.dart';
import 'package:fluter_prjcts/Widgets/Cards/game_setup_card.dart';

class GameTypePage extends StatefulWidget {
  final GameType? selectedGameType;
  final Function(GameType) onGameTypeSelected;
  const GameTypePage({super.key,
    this.selectedGameType,
    required this.onGameTypeSelected,
  });

  @override
  GameTypePageState createState() => GameTypePageState();
}

class GameTypePageState extends State<GameTypePage> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    // Initialize selectedIndex based on the passed selectedGameType
    if (widget.selectedGameType != null) {
      switch (widget.selectedGameType) {
        case GameType.ranked:
          selectedIndex = 0;
          break;
        case GameType.friendly:
          selectedIndex = 1;
          break;
        default:
          selectedIndex = null;
      }
    }
  }

  @override
  void didUpdateWidget(GameTypePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle updates to the selectedGameType
    if (widget.selectedGameType != oldWidget.selectedGameType) {
      if (widget.selectedGameType != null) {
        switch (widget.selectedGameType) {
          case GameType.ranked:
            selectedIndex = 0;
            break;
          case GameType.friendly:
            selectedIndex = 1;
            break;
          default:
            selectedIndex = null;
        }
      } else {
        selectedIndex = null;
      }
    }
  }

  void updateSelection(int index, GameType gameType) {
    setState(() {
      selectedIndex = index;
    });
    widget.onGameTypeSelected(gameType);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        children: [
          const Text("Choose Game Type", style: TextStyle(color: Colors.amber, fontSize: 24)),
          const SizedBox(height: 20),
          Column(
            children: [
              GameSetupCard(
                index: 0,
                isSelected: selectedIndex ==  0,
                onSelect: (index) => updateSelection(index, GameType.ranked),
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.4,
                headerBackColor: const Color(0xFF5DD39E),
                bodyBackColor: const Color(0xFF30323D),
                titleWidget:
                Text("1v1 Ranked",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF30323D),
                  ),
                ),
                descriptionWidget:
                Text("Description: Competitive form of quiz to test your knowledge and be rewarded",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GameSetupCard(
                index: 1,
                isSelected: selectedIndex == 1,
                onSelect: (index) => updateSelection(index, GameType.friendly),
                width:  screenSize.width * 0.8,
                height: screenSize.height * 0.4,
                headerBackColor: const Color(0xFF7173FF),
                bodyBackColor: const Color(0xFF30323D),
                titleWidget: Text("Friendly match",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF30323D),
                  ),
                ),
                descriptionWidget:
                Text("Description: Learn and play with friends to decide who is \nTHE Geek",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
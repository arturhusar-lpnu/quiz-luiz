import 'package:fluter_prjcts/Widgets/Cards/game_setup_card.dart';
import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Models/Enums/game_mode.enum.dart';

class GameModePage extends StatefulWidget{
  final List<GameMode> modes;
  final Function(GameMode) onModeSelected;
  final GameMode? selectedMode;

  const GameModePage({
    super.key,
    required this.onModeSelected,
    this.selectedMode,
    this.modes = const [GameMode.deathRun, GameMode.firstTo15, GameMode.inARow]
  });

  @override
  _GameModeSelectorState createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends State<GameModePage> {
  late PageController _pageController;
  int _currentPage = 0;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );

    // Set initial selected mode if provided
    if (widget.selectedMode != null) {
      final index = widget.modes.indexOf(widget.selectedMode!);
      if (index >= 0) {
        _currentPage = index;
        selectedIndex = index;
        _pageController = PageController(initialPage: index);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void updateSelection(int index, GameMode gameMode) {
    setState(() {
      selectedIndex = index;
    });
    widget.onModeSelected(gameMode);
  }

  void goToNextPage() {
    if (_currentPage < GameMode.values.length) {
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text("Choose Game Mode", style: TextStyle(color: Colors.amber, fontSize: 24)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.modes.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.white : Colors.white24,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // PageView in the center
                PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Disable swiping - use buttons only
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: widget.modes.length,
                  itemBuilder: (context, index) {
                    final gameMode = widget.modes[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Center(
                        child: GameSetupCard(
                          index: index,
                          isSelected: selectedIndex == index,
                          onSelect: (index) => updateSelection(index, gameMode),
                          width: 290,
                          height: 350,
                          headerBackColor: _getHeaderColor(gameMode),
                          headerHeight: 120,
                          bodyBackColor: const Color(0xFF30323D),
                          titleWidget: Text(_getTitle(gameMode),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF30323D),
                            ),
                          ),
                          descriptionWidget: Text(_getDescription(gameMode),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Left arrow button
                if (_currentPage > 0)
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                      onPressed: goToPreviousPage,
                    ),
                  ),

                // Right arrow button
                if (_currentPage < widget.modes.length - 1)
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                      onPressed: goToNextPage,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(GameMode mode) {
    switch (mode) {
      case GameMode.deathRun:
        return 'Death Run';
      case GameMode.firstTo15:
        return 'First to 15';
      case GameMode.inARow:
        return '5 In A Row';
    }
  }

  String _getDescription(GameMode mode) {
    switch (mode) {
      case GameMode.deathRun:
        return 'First to 3 mistakes loses';
      case GameMode.firstTo15:
        return 'First to secure 15 points wins';
      case GameMode.inARow:
        return 'First to get 5 consecutive correct answers wins';
      }
  }

  // Helper function to get mode header color
  Color _getHeaderColor(GameMode mode) {
    switch (mode) {
      case GameMode.deathRun:
        return const Color(0xFF5DD39E);
      case GameMode.firstTo15:
        return const Color(0xFF7173FF);
      case GameMode.inARow:
        return Colors.amber;
      }
  }
}

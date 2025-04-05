import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Actions/Buttons/new_game_mode_buttons.dart';

class NewGameModes extends StatelessWidget{
  const NewGameModes({super.key});

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
            const Text("New Game", style: TextStyle(fontSize: 32, color: Colors.amber)),
            const SizedBox(height: 20,),
            Center(
                child: Row(
                  children: [
                    const SizedBox(width: 10,),
                    SpectateGameButton(
                        text: "Spectate",
                        fontSize: 24,
                        color: Color(0xFFCFB9FF),
                        width: 152,
                        height: 58
                    ),
                    const SizedBox(width: 20,),
                    CreateGameButton(
                        text: "Create",
                        fontSize: 24,
                        color: Color(0xFF5DD39E),
                        width: 152,
                        height: 58
                    ),
                  ],
                )
            )

          ],
        )
    );
  }
}

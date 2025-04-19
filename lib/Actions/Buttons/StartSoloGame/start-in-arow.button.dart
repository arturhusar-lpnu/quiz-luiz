import "package:fluter_prjcts/Firestore/Player/current_player.dart";
import "package:fluter_prjcts/Firestore/Topic/topic.firestore.dart";
import "package:fluter_prjcts/Models/Enums/game_mode.enum.dart";
import "package:fluter_prjcts/Models/Enums/game_type.enum.dart";
import "package:fluter_prjcts/Actions/Buttons/action_button.dart";
import 'package:fluter_prjcts/Models/game.dart';
import "package:fluter_prjcts/Router/router.dart";

class StartInArowSoloButton extends ActionButton {
  StartInArowSoloButton({
    super.key,
    required super.fontSize,
    required super.color,
    required super.width,
    required super.height,
  }) : super(
    text: "Start",
    onPressed: () async {
      final hostId = CurrentPlayer.player!.id;
      final topics = await getUnsolvedTopics(hostId);
      final topicIds = topics.map((t) => t.id).toSet();
      final game = Game(id: "", mode: GameMode.in_a_row, type: GameType.ranked);

      router.go( "/quiz-solo", extra: {
        "hostId": hostId,
        "topicIds": topicIds,
        "game": game.toMap(),}
      );
    },
  );
}
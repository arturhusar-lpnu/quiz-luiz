import 'package:fluter_prjcts/Actions/Buttons/action_button.dart';
import 'package:fluter_prjcts/Router/router.dart';

class SpectateGameButton extends ActionButton {
  SpectateGameButton({
    super.key,
    required super.text,
    required super.fontSize,
    required super.color,
    required super.width,
    required super.height,
  }) : super(
    onPressed: () {
      /// TODO Change to the proper screen
      router.push("/spectate-game");
    },
  );
}

class CreateGameButton extends ActionButton {
  CreateGameButton({
    super.key,
    required super.text,
    required super.fontSize,
    required super.color,
    required super.width,
    required super.height,
  }) : super(
    onPressed: () {
      router.push("/create-game");
    },
  );
}
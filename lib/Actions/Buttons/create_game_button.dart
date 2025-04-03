import 'package:fluter_prjcts/Actions/Buttons/action_button.dart';
import "package:fluter_prjcts/Router/router.dart";

class CreateGameButton extends ActionButton {
  CreateGameButton({
    super.key,
    required super.text,
    required super.color,
    required super.width,
    required super.height,
  }) : super(
    onPressed: () {
      router.go("/new-game");
    },
  );
}

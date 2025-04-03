import 'package:fluter_prjcts/Actions/Buttons/action_button.dart';
import 'package:fluter_prjcts/Router/router.dart';

class PlayButton extends ActionButton {
  PlayButton({
    super.key,
    required super.text,
    required super.color,
    required super.width,
    required super.height,
  }) : super(
    onPressed: () {
      router.go("/games");
    },
  );
}

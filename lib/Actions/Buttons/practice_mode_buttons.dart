import 'package:fluter_prjcts/Actions/Buttons/action_button.dart';
import 'package:fluter_prjcts/Router/router.dart';

class StartMatchWithAiButton extends ActionButton {
  StartMatchWithAiButton({
    super.key,
    required super.text,
    required super.fontSize,
    required super.color,
    required super.width,
    required super.height,
  }) : super(
    onPressed: () {
      router.go("/match-with-ai");
    },
  );
}

class RerunMistakesButton extends ActionButton {
  RerunMistakesButton({
    super.key,
    required super.text,
    required super.fontSize,
    required super.color,
    required super.width,
    required super.height,
  }) : super(
    onPressed: () {
      router.go("/rerun-mistakes");
    },
  );
}
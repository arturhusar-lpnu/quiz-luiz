import 'package:fluter_prjcts/Actions/Buttons/action_button.dart';

class AcceptButton extends ActionButton {
  AcceptButton({
    super.key,
    required super.text,
    required super.color,
    required super.width,
    required super.height,
    required super.textColor,
    required super.fontSize,
  }) : super(
    onPressed: () {
      //router.go("/games");
    },
  );
}
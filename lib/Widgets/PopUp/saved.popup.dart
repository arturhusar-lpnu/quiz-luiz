import "package:fluter_prjcts/Actions/Buttons/action_button.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Router/router.dart";

Future<void> showSaveDialog (BuildContext context, {
  required String message,
}) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.5), // dim background
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: _SavePopup(message: message),
      );
    },
  );
}

class _SavePopup extends StatelessWidget {
  final String message;

  const _SavePopup({required this.message});

  @override
  Widget build(BuildContext context) {
    final Color topColor = Colors.greenAccent;
    final String title = "$message saved!";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: BoxDecoration(
            color: topColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: ActionButton(
                text: "Ok",
                textColor: Colors.black,
                onPressed: () async{
                  router.pop();
                  await Future.delayed(Duration(milliseconds: 200));
                  if (router.canPop()) {
                    router.pop(); // go back to previous screen
                  }
                },
                color: topColor,
                width: 100,
                height: 50
            ),
          ),
        ),
      ],
    );
  }
}

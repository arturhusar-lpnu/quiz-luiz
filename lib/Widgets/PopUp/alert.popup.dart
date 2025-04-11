import "package:fluter_prjcts/Actions/Buttons/action_button.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Router/router.dart";

Future<void> showAlertDialog(BuildContext context, {
  required String message,
}) async{
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.5), // dim background
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: _AlertPopup(message: message),
      );
    },
  );
}

class _AlertPopup extends StatelessWidget {
  final String message;

  const _AlertPopup({required this.message});

  @override
  Widget build(BuildContext context) {
    final Color topColor = Colors.yellowAccent;
    final String title = "Warning";

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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2), // Icon padding
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ),
              Align(
                child:
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
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
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: ActionButton(
                    text: "Ok",
                    textColor: Colors.black,
                    onPressed: () {
                      if(router.canPop()) {
                        router.pop();
                      }
                    },
                    color: topColor,
                    width: 100,
                    height: 50
                ),
              ),
            ],
          ),

        ),
      ],
    );
  }
}

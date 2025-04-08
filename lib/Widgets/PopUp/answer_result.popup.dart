import "package:flutter/material.dart";

void showResultDialog(BuildContext context, {
  required bool isCorrect,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.5), // dim background
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: _ResultPopup(isCorrect: isCorrect),
      );
    },
  );
}

class _ResultPopup extends StatelessWidget {
  final bool isCorrect;

  const _ResultPopup({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final Color topColor = isCorrect ? Colors.greenAccent : Colors.redAccent;
    final String title = isCorrect ? "Correct" : "Whoops!";
    final String message = isCorrect ? "You guessed it right" : "Wrong guess";

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
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

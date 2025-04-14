import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
          context: context,
          bodyBuilder: (context) => const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Tap on Topic Card to see its questions",
              style: TextStyle(fontSize: 16),
            ),
          ),
          direction: PopoverDirection.bottom,
          width: 200,
          arrowHeight: 15,
          arrowWidth: 30,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      child: const Icon(
        Icons.help_outline_rounded,
        color: Colors.amber,
        size: 40,
      ),
    );
  }
}

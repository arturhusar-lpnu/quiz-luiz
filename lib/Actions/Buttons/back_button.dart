import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Router/router.dart';
import 'package:go_router/go_router.dart';

class ReturnBackButton extends StatelessWidget {
  final double radius;
  final Color backColor;
  final Color iconColor;

  const ReturnBackButton({
    super.key,
    required this.backColor,
    required this.iconColor,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
         router.go('/'); // Redirect if no previous page
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), // Circular button
        padding: EdgeInsets.all(radius / 2), // Controls button size
        backgroundColor: backColor,
      ),
      child: Icon(Icons.arrow_back, color: iconColor),
    );
  }
}

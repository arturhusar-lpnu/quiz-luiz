import 'package:flutter/material.dart';
import 'package:fluter_prjcts/Router/router.dart';
import 'package:go_router/go_router.dart';

class ReturnBackButton extends StatelessWidget {
  final Color iconColor;

  const ReturnBackButton({
    super.key,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        } else {
         router.go('/');
        }
      },
      color: iconColor,
    );
  }
}
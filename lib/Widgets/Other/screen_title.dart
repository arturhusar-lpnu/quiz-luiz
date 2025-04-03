import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget{
    final String title;
    const ScreenTitle({super.key, required this.title});

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Text(title, style: TextStyle(fontSize: 32, color: Colors.amber)),
      );
    }
}
import 'package:flutter/material.dart';

class LoadingScreen<T> extends StatelessWidget {
  final Future<T> Function() future;
  final Widget Function(BuildContext, T) builder;

  const LoadingScreen({super.key, required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              color: Color(0xFF4D5061),
              child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor:
                    Color(0xFF4D5061),
                  )
              ),
            )

          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else {
          return builder(context, snapshot.data as T);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

class LoadingScreen<T> extends StatelessWidget {
  final Future<T> Function() future;
  final Widget Function(BuildContext, T) builder;
  final Color backgroundColor;
  final String loadingText;

  const LoadingScreen({
    super.key,
    required this.future,
    required this.builder,
    required this.loadingText,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              color: backgroundColor,
              padding: EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Color(0xFF4D5061),
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          loadingText,
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
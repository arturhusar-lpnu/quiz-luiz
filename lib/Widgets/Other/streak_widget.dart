import 'package:flutter/material.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  Future<int> _fetchDays() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a network request
    return 4; // Example value
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: Colors.orange,
            size: 32,
          ),
          const SizedBox(width: 12),
          // FutureBuilder to fetch the data asynchronously
          FutureBuilder<int>(
            future: _fetchDays(),
            builder: (context, snapshot) {
              // Handling the different states of the Future
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  "Loading...",
                  style: TextStyle(fontSize: 18, color: Colors.amber),
                );
              } else if (snapshot.hasError) {
                return const Text(
                  "Error fetching data",
                  style: TextStyle(fontSize: 18, color: Colors.amber),
                );
              } else if (snapshot.hasData) {
                return Text(
                  "${snapshot.data} Days streak",
                  style: const TextStyle(fontSize: 18, color: Colors.amber),
                );
              } else {
                return const Text(
                  "No Data Available",
                  style: TextStyle(fontSize: 18, color: Colors.amber),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

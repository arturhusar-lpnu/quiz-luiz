import 'package:fluter_prjcts/Blocs/StreakBloc/streak_bloc.dart';
import 'package:fluter_prjcts/Firestore/Player/current_player.dart';
import 'package:fluter_prjcts/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluter_prjcts/Widgets/PopUp/error.popup.dart';


class StreakWidget extends StatefulWidget {
  const StreakWidget({super.key});

  @override
  State<StreakWidget> createState() => _StreakState();
}

class _StreakState extends State<StreakWidget> {
  late StreakBloc sBloc;

  @override
  void initState() {
    super.initState();
    final currentPlayer = CurrentPlayer.player;
    sBloc = context.maybeRead<StreakBloc>() ?? StreakBloc();
    sBloc.add(SubscribeStreakEvent(currentPlayer!.id));
  }

  @override
  void dispose() {
    //sBloc.close();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sBloc,
      child: BlocBuilder<StreakBloc, StreakState>(
          builder: (context, state) {
            if(state is StreakLoadSuccess) {
              final streak = state.streak;
              final hasData = streak > 0;
              final iconColor = hasData ? Colors.amber : Colors.grey;
              final textColor = hasData ? Colors.amber : Colors.grey;
              final displayText = hasData ? "$streak Days Streak" : "Keep it up";
              return _buildStreak(iconColor, displayText, textColor);
            } else if (state is StreakLoadFail) {
              showErrorDialog(
                context: context,
                icon: Icons.error_outlined, title: 'Api Error',
                message: state.errorMessage,
                onRetry: () {  },
              );
              return SizedBox(height: 0);
            }
            return Column(
              children: [
                const Center(
                    child: Text(
                        "Loading...")
                ),
                CircularProgressIndicator()
              ],
            );
          }
      ),
    );
  }

  Container _buildStreak(Color iconColor, String displayText, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D4D),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
      Row(
          children: [
            Icon(
              Icons.local_fire_department_rounded,
              color: iconColor,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              displayText,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
          ]
      ),
    );
  }
}

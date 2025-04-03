enum MatchResult { Draw, Win, Loss }

class MatchHistoryDetails {
  final MatchResult result;
  final String type;
  final String topics;

  MatchHistoryDetails({
    required this.result,
    required this.type,
    required this.topics
  });
}
class RankedPlayer {
  final String playerId;
  final String username;
  final int points;
  late int rank;

  RankedPlayer({
    required this.playerId,
    required this.username,
    required this.points,
  });
}
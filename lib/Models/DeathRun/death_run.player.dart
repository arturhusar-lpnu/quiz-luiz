class DeathRunPlayer {
  final int fails;
  final int score;

  DeathRunPlayer({required this.fails, required this.score});

  factory DeathRunPlayer.fromMap(Map<String, dynamic> data) {
    return DeathRunPlayer(
      fails: data['fails'],
      score: data['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fails': fails,
      'score': score,
    };
  }
}

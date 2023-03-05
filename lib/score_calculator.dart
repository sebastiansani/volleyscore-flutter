import 'package:volleyscore/math_utils.dart';
import 'package:volleyscore/storage.dart';

class ScoreCalculator {
  static int calculateScore(
      VolleyScorePlayer player, List<VolleyScoreMatch> matches) {
    matches = matches
        .where((match) =>
            match.players.contains(player) &&
            match.winningTeam.score != match.losingTeam.score)
        .toList();
    if (matches.isEmpty) {
      return 50;
    }

    double scoreOffset = 0;
    for (final match in matches) {
      double matchOffset =
          (match.winningTeam.score - match.losingTeam.score).toDouble();
      if (match.losingTeam.players.contains(player)) {
        matchOffset = -matchOffset;
      }
      matchOffset /= match.winningTeam.score;
      scoreOffset += matchOffset;
    }
    scoreOffset /= matches.length;

    return ((tanh(scoreOffset) + 1) * 50).round();
  }

  static int calculateWinRate(
      VolleyScorePlayer player, List<VolleyScoreMatch> matches) {
    final allMatches = matches
        .where((match) =>
            match.players.contains(player) &&
            match.winningTeam.score != match.losingTeam.score)
        .toList();
    final wonMatches = allMatches
        .where((match) => match.winningTeam.players.contains(player))
        .toList();

    if (allMatches.isEmpty) {
      return 0;
    }

    return (wonMatches.length / allMatches.length * 100).round();
  }
}

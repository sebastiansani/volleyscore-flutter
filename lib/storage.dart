import 'package:flutter/material.dart';

class VolleyScoreTeam {
  List<Player> players;
  String name;
  int score = 0;

  VolleyScoreTeam(this.name, this.players);
}

class VolleyScoreMatch {
  late DateTime date;
  VolleyScoreTeam team1;
  VolleyScoreTeam team2;

  // get players
  List<Player> get players => [
        ...team1.players,
        ...team2.players,
      ];

  VolleyScoreMatch(this.team1, this.team2) {
    date = DateTime.now();
  }
}

class Player {
  final String name;
  bool isPlaying;

  Player(this.name, {this.isPlaying = true});
}

class PlayerMatchesStorage with ChangeNotifier {
  final List<VolleyScoreMatch> _matches = [
    VolleyScoreMatch(
      VolleyScoreTeam(
        'Los Cojos',
        [
          Player('Player 1'),
          Player('Player 2'),
          Player('Player 3'),
          Player('Player 4'),
        ],
      ),
      VolleyScoreTeam(
        'A caso',
        [
          Player('Player 5'),
          Player('Player 6'),
          Player('Player 7'),
          Player('Player 8'),
        ],
      ),
    ),
  ];
  final List<Player> _players = [
    Player('Player 1'),
    Player('Player 2'),
    Player('Player 3'),
    Player('Player 4'),
    Player('Player 5'),
    Player('Player 6'),
    Player('Player 7'),
    Player('Player 8'),
    Player('Player 9'),
    Player('Player 10'),
    Player('Player 11'),
    Player('Player 12'),
    Player('Player 13'),
    Player('Player 14'),
    Player('Player 15'),
    Player('Player 16'),
  ];

  List<VolleyScoreMatch> get matches => _matches;
  List<Player> get players => _players;

  List<VolleyScoreMatch> getPlayerMatches(Player player) {
    return _matches.where((match) => match.players.contains(player)).toList();
  }

  int getPlayerNumberOfWonMatches(Player player) {
    return getPlayerMatches(player)
            .where((match) => match.team1.players.contains(player))
            .where((match) => match.team1.score > match.team2.score)
            .length +
        getPlayerMatches(player)
            .where((match) => match.team2.players.contains(player))
            .where((match) => match.team2.score > match.team1.score)
            .length;
  }

  int getPlayerWinRate(Player player) {
    int wonMatches = getPlayerNumberOfWonMatches(player);
    int totalMatches = getPlayerMatches(player).length;
    if (totalMatches == 0) {
      return 0;
    }
    return (wonMatches / totalMatches * 100).round();
  }

  void addMatch(VolleyScoreMatch match) {
    _matches.add(match);
    notifyListeners();
  }

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void removePlayer(Player player) {
    _players.remove(player);
    notifyListeners();
  }

  void removeMatch(VolleyScoreMatch match) {
    _matches.remove(match);
    notifyListeners();
  }

  void addPoint(VolleyScoreTeam team) {
    team.score++;
    notifyListeners();
  }

  void removePoint(VolleyScoreTeam team) {
    if (team.score > 0) {
      team.score--;
      notifyListeners();
    }
  }

  void togglePlayerPlaying(Player player) {
    player.isPlaying = !player.isPlaying;
    notifyListeners();
  }
}

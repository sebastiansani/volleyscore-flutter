import 'package:flutter/material.dart';

class VolleyScoreTeam {
  final String name;
  final List<Player> players;
  int score = 0;

  VolleyScoreTeam(this.name, this.players);

  void addPoint() {
    score++;
  }

  void removePoint() {
    score--;
  }
}

class VolleyScoreMatch {
  final DateTime date;
  final List<Player> players;
  late VolleyScoreTeam team1;
  late VolleyScoreTeam team2;

  void randomizeTeams() {
    players.shuffle();
    int half = players.length ~/ 2;
    team1 = VolleyScoreTeam('Team 1', players.sublist(0, half));
    team2 = VolleyScoreTeam('Team 2', players.sublist(half));
  }

  VolleyScoreMatch(this.date, this.players) {
    randomizeTeams();
  }
}

class Player {
  final String name;
  bool isPlaying;

  Player(this.name, {this.isPlaying = true});
}

class PlayerMatchesStorage with ChangeNotifier {
  final List<VolleyScoreMatch> _matches = [
    VolleyScoreMatch(DateTime.now(), [
      Player('Player 1'),
      Player('Player 2'),
      Player('Player 3'),
      Player('Player 4'),
    ]),
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
    team.addPoint();
    notifyListeners();
  }

  void removePoint(VolleyScoreTeam team) {
    if (team.score > 0) {
      team.removePoint();
      notifyListeners();
    }
  }

  void togglePlayerPlaying(Player player) {
    player.isPlaying = !player.isPlaying;
    notifyListeners();
  }
}

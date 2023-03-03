import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volleyscore/math_utils.dart';

class VolleyScoreTeam {
  List<VolleyScorePlayer> players;
  String name;
  int score = 0;

  VolleyScoreTeam(this.name, this.players);

  VolleyScoreTeam.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        players = (json['players'] as List)
            .map((player) => VolleyScorePlayer.fromJson(player))
            .toList(),
        score = json['score'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'players': players.map((player) => player.toJson()).toList(),
        'score': score,
      };
}

class VolleyScoreMatch {
  late DateTime date;
  VolleyScoreTeam team1;
  VolleyScoreTeam team2;

  String get key => date.toIso8601String();

  VolleyScoreTeam get winningTeam => team1.score > team2.score ? team1 : team2;
  VolleyScoreTeam get losingTeam => team1.score > team2.score ? team2 : team1;

  // get players
  List<VolleyScorePlayer> get players => [
        ...team1.players,
        ...team2.players,
      ];

  VolleyScoreMatch(this.team1, this.team2) {
    date = DateTime.now();
  }

  VolleyScoreMatch.fromJson(Map<String, dynamic> json)
      : team1 = VolleyScoreTeam.fromJson(json['team1']),
        team2 = VolleyScoreTeam.fromJson(json['team2']),
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() => {
        'team1': team1.toJson(),
        'team2': team2.toJson(),
        'date': date.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolleyScoreMatch &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}

class VolleyScorePlayer {
  final String name;
  bool isPlaying;

  String get key => name;

  VolleyScorePlayer(this.name, {this.isPlaying = true});

  VolleyScorePlayer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        isPlaying = true;

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolleyScorePlayer &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}

class PlayerMatchesStorage with ChangeNotifier {
  late List<VolleyScoreMatch> _matches;
  late List<VolleyScorePlayer> _players;
  late SharedPreferences _prefs;

  void loadPrefs(prefs) {
    _prefs = prefs;
    loadPlayers();
    loadMatches();
  }

  void loadPlayers() {
    final playersString = _prefs.getString('players');
    if (playersString != null) {
      _players = (jsonDecode(playersString) as List)
          .map((player) => VolleyScorePlayer.fromJson(player))
          .toList();
    } else {
      _players = [];
    }
  }

  void savePlayers() {
    _prefs.setString('players', jsonEncode(_players));
  }

  void loadMatches() {
    final matchesString = _prefs.getString('matches');
    if (matchesString != null) {
      _matches = (jsonDecode(matchesString) as List)
          .map((match) => VolleyScoreMatch.fromJson(match))
          .toList();
    } else {
      _matches = [];
    }
  }

  void saveMatches() {
    _prefs.setString('matches', jsonEncode(_matches));
  }

  List<VolleyScoreMatch> get matches => _matches;
  List<VolleyScorePlayer> get players => _players;

  List<VolleyScoreMatch> getPlayerMatches(VolleyScorePlayer player) {
    return _matches.where((match) => match.players.contains(player)).toList();
  }

  Iterable<VolleyScoreMatch> getPlayerWonMatches(VolleyScorePlayer player) {
    return getPlayerMatches(player)
        .where((match) => match.winningTeam.players.contains(player));
  }

  int getPlayerWinRate(VolleyScorePlayer player) {
    final wonMatches = getPlayerWonMatches(player).length;
    final totalMatches = getPlayerMatches(player).length;
    if (totalMatches == 0) {
      return 0;
    }
    return (wonMatches / totalMatches * 100).round();
  }

  int getPlayerScore(VolleyScorePlayer player) {
    final matches = getPlayerMatches(player);
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

  void addPlayer(VolleyScorePlayer player) {
    if (!_players.contains(player)) {
      _players.add(player);
    }
    notifyListeners();
    savePlayers();
  }

  void removePlayer(VolleyScorePlayer player) {
    _players.remove(player);
    notifyListeners();
    savePlayers();
  }

  void togglePlayerPlaying(VolleyScorePlayer player) {
    player.isPlaying = !player.isPlaying;
    notifyListeners();
  }

  void toggleAllPlayersPlaying() {
    for (final player in _players) {
      player.isPlaying = true;
    }
    notifyListeners();
  }

  void removeMatch(VolleyScoreMatch match) {
    _matches.remove(match);
    notifyListeners();
    saveMatches();
  }

  void addMatch(VolleyScoreMatch match) {
    if (!_matches.contains(match)) {
      _matches.add(match);
    }
    notifyListeners();
    saveMatches();
  }
}

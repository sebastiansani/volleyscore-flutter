import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolleyScoreTeam {
  List<Player> players;
  String name;
  int score = 0;

  VolleyScoreTeam(this.name, this.players);

  VolleyScoreTeam.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        players = (json['players'] as List)
            .map((player) => Player.fromJson(player))
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
  List<Player> get players => [
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
}

class Player {
  final String name;
  bool isPlaying;

  String get key => name;

  Player(this.name, {this.isPlaying = true});

  Player.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        isPlaying = true;

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}

class PlayerMatchesStorage with ChangeNotifier {
  late List<VolleyScoreMatch> _matches;
  late List<Player> _players;
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
          .map((player) => Player.fromJson(player))
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
  List<Player> get players => _players;

  List<VolleyScoreMatch> getPlayerMatches(Player player) {
    return _matches.where((match) => match.players.contains(player)).toList();
  }

  int getPlayerNumberOfWonMatches(Player player) {
    return getPlayerMatches(player)
        .where((match) => match.winningTeam.players.contains(player))
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

  void addPlayer(Player player) {
    if (!_players.contains(player)) {
      _players.add(player);
    }
    notifyListeners();
    savePlayers();
  }

  void removePlayer(Player player) {
    _players.remove(player);
    notifyListeners();
    savePlayers();
  }

  void togglePlayerPlaying(Player player) {
    player.isPlaying = !player.isPlaying;
    notifyListeners();
  }

  void removeMatch(VolleyScoreMatch match) {
    _matches.remove(match);
    notifyListeners();
    saveMatches();
  }

  void addMatch(VolleyScoreMatch match) {
    final idx = matches.indexWhere((m) => m.key == match.key);
    if (idx != -1) {
      _matches[idx] = match;
    } else {
      _matches.add(match);
    }
    notifyListeners();
    saveMatches();
  }
}

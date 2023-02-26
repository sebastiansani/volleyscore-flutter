import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/storage.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({super.key, required this.propMatch});
  final VolleyScoreMatch propMatch;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: true);
    final match = store.matches.firstWhere((element) => element == propMatch);
    final titleStyle =
        Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 75);

    final winningTeam =
        match.team1.score > match.team2.score ? match.team1 : match.team2;
    final losingTeam =
        match.team1.score < match.team2.score ? match.team1 : match.team2;

    final isMatchPoint =
        winningTeam.score >= 24 && winningTeam.score != losingTeam.score;
    final isMatchOver =
        winningTeam.score >= 25 && winningTeam.score - losingTeam.score >= 2;

    Widget statusWidget = const SizedBox();
    if (isMatchPoint) {
      statusWidget =
          Text('ROJO!', style: titleStyle?.copyWith(color: Colors.red));
    }
    if (isMatchOver) {
      statusWidget = Text('Vince ${winningTeam.name}!',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.green, fontSize: 50));
    }

    Widget buildScoreCard(VolleyScoreTeam team) {
      return SizedBox(
        width: 100,
        child: Card(
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  if (isMatchOver) {
                    return;
                  }
                  store.addPoint(team);
                },
                icon: const Icon(Icons.add),
              ),
              Text(
                team.score.toString().padLeft(2, '0'),
                style: titleStyle,
              ),
              IconButton(
                onPressed: () {
                  store.removePoint(team);
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildTeamColumn(VolleyScoreTeam team) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            team.name,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          ...team.players.map((e) => Text(e.name)).toList(),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Match'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildScoreCard(match.team1),
                  Text(' - ', style: titleStyle),
                  buildScoreCard(match.team2),
                ],
              ),
              const SizedBox(height: 20),
              statusWidget,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTeamColumn(match.team1),
                  const SizedBox(width: 40),
                  buildTeamColumn(match.team2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

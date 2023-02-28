import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/homePage.dart';
import 'package:volleyscore/storage.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key, required this.propMatch});
  final VolleyScoreMatch propMatch;

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  late VolleyScoreMatch match;

  @override
  void initState() {
    match = widget.propMatch;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      statusWidget = Text(
        'Vince ${winningTeam.name}!',
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(color: Colors.green, fontSize: 50),
        textAlign: TextAlign.center,
      );
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
                  setState(() {
                    team.score++;
                  });
                },
                icon: const Icon(Icons.add),
              ),
              Text(
                team.score.toString().padLeft(2, '0'),
                style: titleStyle,
              ),
              IconButton(
                onPressed: () {
                  if (team.score == 0) {
                    return;
                  }
                  setState(() {
                    team.score--;
                  });
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildTeamColumn(VolleyScoreTeam team) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              team.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            ...team.players.map((e) => Text(e.name)).toList(),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Partita'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(match.date),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 20),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTeamColumn(match.team1),
                    const SizedBox(width: 40),
                    buildTeamColumn(match.team2),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final store =
                  Provider.of<PlayerMatchesStorage>(context, listen: false);
              store.addMatch(match);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false);
            },
            child: const Icon(Icons.check),
          )),
    );
  }
}

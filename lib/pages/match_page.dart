import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/home_page.dart';
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

    final winningTeam = match.winningTeam;
    final losingTeam = match.losingTeam;

    final isMatchPoint =
        winningTeam.score >= 24 && winningTeam.score != losingTeam.score;
    final isMatchOver =
        winningTeam.score >= 25 && winningTeam.score - losingTeam.score >= 2;

    Widget statusWidget = Container();
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
      final controller =
          TextEditingController(text: team.score.toString().padLeft(2, '0'));

      return SizedBox(
        width: 100,
        child: Card(
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    team.score++;
                  });
                },
                icon: const Icon(Icons.add),
              ),
              TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  setState(() {
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null || parsedValue < 0) {
                      return;
                    }
                    team.score = parsedValue;
                    controller.text = value;
                  });
                },
                controller: controller,
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
            actions: [
              IconButton(
                iconSize: 25,
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Elimina match'),
                      content: const Text('Sei sicuro di voler cancellare questo match?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Indietro'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              final store = Provider.of<PlayerMatchesStorage>(
                                  context,
                                  listen: false);
                              store.removeMatch(match);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                  (route) => false);
                            });
                          },
                          child: const Text('Elimina'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Padding(
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

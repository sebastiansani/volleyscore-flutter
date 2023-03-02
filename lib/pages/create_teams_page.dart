import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/match_page.dart';
import 'package:volleyscore/storage.dart';

class CreateTeamsPage extends StatefulWidget {
  const CreateTeamsPage({super.key, required this.players});
  final List<VolleyScorePlayer> players;

  @override
  State<CreateTeamsPage> createState() => _CreateTeamsPageState();
}

class _CreateTeamsPageState extends State<CreateTeamsPage> {
  late TextEditingController team1LabelController;
  late TextEditingController team2LabelController;
  late VolleyScoreTeam team1;
  late VolleyScoreTeam team2;

  void shuffleTeams() {
    setState(() {
      widget.players.shuffle();
      final half = widget.players.length ~/ 2;
      final firstHalf = widget.players.sublist(0, half);
      final secondHalf = widget.players.sublist(half);
      final headsOrTails = Random.secure().nextBool();
      team1.players = headsOrTails ? firstHalf : secondHalf;
      team2.players = headsOrTails ? secondHalf : firstHalf;
    });
  }

  @override
  void initState() {
    super.initState();
    team1 = VolleyScoreTeam('Los Cojos', []);
    team2 = VolleyScoreTeam('Bomberos', []);
    team1LabelController = TextEditingController(text: team1.name);
    team2LabelController = TextEditingController(text: team2.name);
    shuffleTeams();
  }

  @override
  void dispose() {
    team1LabelController.dispose();
    team2LabelController.dispose();
    super.dispose();
  }

  Widget buildTeamColumn(bool isTeam1, PlayerMatchesStorage store) {
    final team = isTeam1 ? team1 : team2;
    final otherTeam = isTeam1 ? team2 : team1;
    final controller = isTeam1 ? team1LabelController : team2LabelController;
    final playerCount = team.players.length;

    final averageWinRate = team.players.isEmpty
        ? 0
        : team.players
                .map((e) => store.getPlayerWinRate(e))
                .reduce((a, b) => a + b) /
            team.players.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
          isTeam1 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        TextField(
          textAlign: isTeam1 ? TextAlign.start : TextAlign.end,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Nome team',
          ),
          onSubmitted: (value) {
            setState(() {
              team.name = value;
              controller.text = value;
            });
          },
          controller: controller,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          '${team.players.length} Giocator${playerCount == 1 ? 'e' : 'i'}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          '${averageWinRate.toInt().toString()}% Winrate medio',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        ...team.players.map((e) {
          var elements = [
            Icon(isTeam1 ? Icons.arrow_right : Icons.arrow_left),
            Text(e.name),
          ];

          if (isTeam1) {
            elements = elements.reversed.toList();
          }

          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: elements,
              ),
              onTap: () {
                setState(() {
                  otherTeam.players.add(e);
                  team.players.remove(e);
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Crea team'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 18, left: 18),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Stack(children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildTeamColumn(true, store),
                        ),
                        Expanded(
                          child: buildTeamColumn(false, store),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: MediaQuery.of(context).size.width / 2 - 50,
                    child: Ink(
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          shuffleTeams();
                        },
                        child: const Icon(Icons.shuffle),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            final match = VolleyScoreMatch(team1, team2);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MatchPage(
                    propMatch: match,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
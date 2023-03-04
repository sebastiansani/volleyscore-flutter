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
  late VolleyScoreTeam team1;
  late VolleyScoreTeam team2;

  void assignTeamsRandomly(List<VolleyScorePlayer> players) {
    final half = players.length ~/ 2;
    final firstHalf = players.sublist(0, half);
    final secondHalf = players.sublist(half);
    final headsOrTails = Random.secure().nextBool();
    team1.players = headsOrTails ? firstHalf : secondHalf;
    team2.players = headsOrTails ? secondHalf : firstHalf;
  }

  void shuffleTeams() {
    setState(() {
      widget.players.shuffle();
      assignTeamsRandomly(widget.players);
    });
  }

  int getShuffleScore(
      List<VolleyScorePlayer> players, PlayerMatchesStorage store) {
    final half = widget.players.length ~/ 2;
    final firstHalf = players.sublist(0, half);
    final secondHalf = players.sublist(half);
    return (firstHalf
                .map((e) => store.getPlayerScore(e))
                .reduce((a, b) => a + b) -
            secondHalf
                .map((e) => store.getPlayerScore(e))
                .reduce((a, b) => a + b))
        .abs();
  }

  void smartShuffle(PlayerMatchesStorage store) {
    setState(() {
      final tries = List<int>.generate(10, (i) => i);
      final bestShuffle = tries
          .map((e) => [...widget.players]..shuffle())
          .reduce((a, b) =>
              getShuffleScore(a, store) < getShuffleScore(b, store) ? a : b);

      assignTeamsRandomly(bestShuffle);
    });
  }

  @override
  void initState() {
    super.initState();
    team1 = VolleyScoreTeam('Los Cojos', []);
    team2 = VolleyScoreTeam('Bomberos', []);
    shuffleTeams();
  }


  Widget buildTeamColumn(bool isTeam1, PlayerMatchesStorage store) {
    final team = isTeam1 ? team1 : team2;
    final otherTeam = isTeam1 ? team2 : team1;
    final controller = TextEditingController(text: team.name);
    final playerCount = team.players.length;

    final averageScore = team.players.isEmpty
        ? 0
        : team.players
                .map((e) => store.getPlayerScore(e))
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
          '${averageScore.toInt().toString()} Score medio',
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
                    bottom: 20,
                    child: Row(
                      children: [
                        Ink(
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
                        const SizedBox(width: 20),
                        Ink(
                          decoration: const ShapeDecoration(
                            shape: CircleBorder(),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              smartShuffle(store);
                            },
                            child: const Icon(Icons.lightbulb),
                          ),
                        ),
                      ],
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

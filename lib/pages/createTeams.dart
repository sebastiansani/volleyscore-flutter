import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/matchPage.dart';
import 'package:volleyscore/storage.dart';

class CreateTeams extends StatefulWidget {
  const CreateTeams({super.key, required this.players});
  final List<Player> players;

  @override
  State<CreateTeams> createState() => _CreateTeamsState();
}

class _CreateTeamsState extends State<CreateTeams> {
  late TextEditingController team1LabelController;
  late TextEditingController team2LabelController;
  late VolleyScoreTeam team1;
  late VolleyScoreTeam team2;

  void shuffleTeams() {
    setState(() {
      widget.players.shuffle();
      int half = widget.players.length ~/ 2;
      team1.players = widget.players.sublist(0, half);
      team2.players = widget.players.sublist(half);
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

  Widget buildTeamColumn(bool isTeam1) {
    final team = isTeam1 ? team1 : team2;
    final otherTeam = isTeam1 ? team2 : team1;
    final controller = isTeam1 ? team1LabelController : team2LabelController;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
        const SizedBox(height: 20),
        ...team.players.map((e) {
          var elements = [
            IconButton(
              onPressed: () {
                setState(() {
                  otherTeam.players.add(e);
                  team.players.remove(e);
                });
              },
              icon: Icon(isTeam1 ? Icons.arrow_right : Icons.arrow_left),
            ),
            Text(e.name),
          ];

          if (isTeam1) {
            elements = elements.reversed.toList();
          }

          return Row(
            mainAxisAlignment:
                isTeam1 ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: elements,
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(children: [
                  Row(
                    children: [
                      Expanded(
                        child: buildTeamColumn(true),
                      ),
                      Expanded(
                        child: buildTeamColumn(false),
                      ),
                    ],
                  ),
                  Center(
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

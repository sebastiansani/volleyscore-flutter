import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/match_page.dart';
import 'package:volleyscore/storage.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.match});
  final VolleyScoreMatch match;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: ListTile(
            trailing: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(colors: [
                      const Color.fromARGB(255, 53, 53, 53),
                      Theme.of(context).primaryColor,
                    ]).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text('${match.team1.score}-${match.team2.score}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                ]),
            title: Text('${match.team1.name} vs ${match.team2.name}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(match.date),
            ),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchPage(propMatch: match),
                  ),
                ),
            onLongPress: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final team1 = VolleyScoreTeam(
                                match.team1.name, match.team1.players);
                            final team2 = VolleyScoreTeam(
                                match.team2.name, match.team2.players);
                            final newMatch = VolleyScoreMatch(team1, team2);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MatchPage(propMatch: newMatch),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.copy),
                              SizedBox(width: 8),
                              Text('Duplica'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            final store = Provider.of<PlayerMatchesStorage>(
                                context,
                                listen: false);
                            store.removeMatch(match);
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Elimina'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

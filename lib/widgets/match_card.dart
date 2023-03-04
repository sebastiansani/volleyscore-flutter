import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Duplica partita'),
                  content: const Text(
                      'Sei sicuro di voler duplicare questa partita?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Indietro'),
                    ),
                    TextButton(
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
                      child: const Text('Duplica'),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

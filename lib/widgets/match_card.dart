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
        ),
      ),
    );
  }
}

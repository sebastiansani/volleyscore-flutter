import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/match.dart';
import 'package:volleyscore/storage.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.match});
  final VolleyScoreMatch match;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerMatchesStorage>(
      builder: (context, store, child) => SizedBox(
        height: 80,
        child: Card(
          child: ListTile(
            title: Text(
                '${match.team1.name} vs ${match.team2.name} (${match.team1.score} - ${match.team2.score})'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(match.date)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                store.removeMatch(match);
              },
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchPage(propMatch: match),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

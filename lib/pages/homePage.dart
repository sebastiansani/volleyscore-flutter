import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/editPlayers.dart';
import 'package:volleyscore/pages/selectPlayers.dart';
import 'package:volleyscore/storage.dart';
import 'package:volleyscore/widgets/matchCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Volley Score',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditPlayers(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Partite recenti:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Expanded(
                child: store.matches.isEmpty
                    ? const Center(child: Text('Nessuna partita'))
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: store.matches.length,
                        itemBuilder: (context, index) {
                          return MatchCard(match: store.matches[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectPlayers(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

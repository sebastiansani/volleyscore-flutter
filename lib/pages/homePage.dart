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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Volley Score'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
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
          child: Consumer<PlayerMatchesStorage>(
            builder: (context, store, child) => store.matches.isEmpty
                ? const Center(child: Text('No matches yet'))
                : Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: ListView.builder(
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

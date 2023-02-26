import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/selectTeams.dart';
import 'package:volleyscore/storage.dart';

class SelectPlayers extends StatelessWidget {
  const SelectPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seleziona giocatori'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: store.players.isEmpty
                      ? const Center(child: Text('Nessun giocatore'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: store.players.length,
                          padding: const EdgeInsets.only(bottom: 80),
                          itemBuilder: (context, index) {
                            final player = store.players[index];

                            return SizedBox(
                              height: 60,
                              child: Card(
                                child: ListTile(
                                  title: Text(player.name),
                                  trailing: Checkbox(
                                    value: player.isPlaying,
                                    onChanged: (value) {},
                                  ),
                                  onTap: () =>
                                      store.togglePlayerPlaying(player),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ]),
        ),
        floatingActionButton: store.players.isEmpty
            ? Container()
            : FloatingActionButton(
                child: const Icon(Icons.check),
                onPressed: () {
                  final activePlayers = store.players
                      .where((player) => player.isPlaying)
                      .toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectTeams(players: activePlayers),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
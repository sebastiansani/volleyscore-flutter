import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/createTeams.dart';
import 'package:volleyscore/storage.dart';

class SelectPlayers extends StatelessWidget {
  const SelectPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: true);
    final activePlayers =
        store.players.where((player) => player.isPlaying).toList();

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

                            return Card(
                              child: Center(
                                child: ListTile(
                                  title: Text(player.name),
                                  trailing: Checkbox(
                                    value: player.isPlaying,
                                    onChanged: (_) {
                                      store.togglePlayerPlaying(player);
                                    },
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
        floatingActionButton: activePlayers.isEmpty
            ? Container()
            : FloatingActionButton.extended(
                label: Text('${activePlayers.length} Giocatori'),
                icon: const Icon(Icons.check),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTeams(players: activePlayers),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

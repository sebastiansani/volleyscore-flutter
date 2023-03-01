import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/storage.dart';

class EditPlayers extends StatelessWidget {
  const EditPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    final fieldText = TextEditingController();
    final store = Provider.of<PlayerMatchesStorage>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modifica giocatori'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: store.players.isEmpty
                    ? const Center(child: Text('Nessun giocatore'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        shrinkWrap: true,
                        itemCount: store.players.length,
                        itemBuilder: (context, index) {
                          final player = store.players[index];
                          return Card(
                            child: Center(
                              child: ListTile(
                                title: Text(player.name),
                                subtitle: Text('Winrate: ${store.getPlayerWinRate(player)}%'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    store.removePlayer(player);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                void onSubmit() {
                  final value = fieldText.text;
                  if (value.isEmpty) return;
                  store.addPlayer(Player(value));
                  fieldText.clear();
                  Navigator.pop(context);
                }

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Nuovo giocatore',
                      ),
                      onSubmitted: (_) => onSubmit(),
                      controller: fieldText,
                      autofocus: true,
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

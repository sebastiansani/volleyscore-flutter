import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/storage.dart';

class EditPlayers extends StatelessWidget {
  const EditPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    final fieldText = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aggiungi giocatori'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nuovo giocatore',
                  ),
                  onSubmitted: (value) {
                    context
                        .read<PlayerMatchesStorage>()
                        .addPlayer(Player(value));
                    fieldText.clear();
                  },
                  controller: fieldText,
                ),
              ),
              Consumer<PlayerMatchesStorage>(
                builder: (context, store, child) => store.players.isEmpty
                    ? const Center(child: Text('Nessun giocatore'))
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 10),
                          shrinkWrap: true,
                          itemCount: store.players.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 60,
                              child: Card(
                                child: ListTile(
                                  title: Text(store.players[index].name),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      store.removePlayer(store.players[index]);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/select_players_page.dart';
import 'package:volleyscore/storage.dart';
import 'package:volleyscore/widgets/match_card.dart';
import 'package:volleyscore/widgets/player_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget matchesTab(BuildContext context, PlayerMatchesStorage store) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: store.matches.isEmpty
                ? const Center(child: Text('Nessuna partita'))
                : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: store.matches.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Partite recenti:',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        );
                      }
                      return MatchCard(match: store.matches[index - 1]);
                    },
                  ),
          ),
        ],
      );

  Widget playersTab(BuildContext context, PlayerMatchesStorage store) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: store.players.isEmpty
                ? const Center(child: Text('Nessun giocatore'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    shrinkWrap: true,
                    itemCount: store.players.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Giocatori:',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        );
                      }

                      return PlayerCard(player: store.players[index - 1]);
                    },
                  ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: true);
    final fieldText = TextEditingController();

    final tabs = [
      matchesTab(context, store),
      playersTab(context, store),
    ];

    final actions = [
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectPlayersPage(),
          ),
        );
      },
      () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            void onSubmit() {
              final value = fieldText.text;
              if (value.isEmpty) return;
              store.addPlayer(VolleyScorePlayer(value));
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
      }
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Volley Score',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: tabs[_selectedIndex]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            actions[_selectedIndex]();
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_volleyball),
              label: 'Partite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face),
              label: 'Giocatori',
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.shifting,
          onTap: (value) => setState(() => _selectedIndex = value),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

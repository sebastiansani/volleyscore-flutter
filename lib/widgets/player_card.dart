import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/storage.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key, required this.player});
  final VolleyScorePlayer player;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: true);

    return Card(
      child: Center(
        child: ListTile(
          leading: Flex(
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
                  child: SizedBox(
                    width: 35,
                    child: Text(
                      store.getPlayerScore(player).toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ]),
          title: Text(player.name),
          subtitle: Text('Winrate: ${store.getPlayerWinRate(player)}%'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Elimina giocatore'),
                  content: const Text(
                      'Sei sicuro di voler cancellare questo giocatore?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Indietro'),
                    ),
                    TextButton(
                      onPressed: () {
                        store.removePlayer(player);
                        Navigator.pop(context);
                      },
                      child: const Text('Elimina'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

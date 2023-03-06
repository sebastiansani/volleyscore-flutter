import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/pages/player_page.dart';
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(player.name),
          subtitle: Text('Winrate: ${store.getPlayerWinRate(player)}%'),
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
            ],
          ),
          onLongPress: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          store.removePlayer(player);
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Elimina'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerPage(propPlayer: player),
            ),
          ),
        ),
      ),
    );
  }
}

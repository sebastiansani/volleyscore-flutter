import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:volleyscore/score_calculator.dart';
import 'package:volleyscore/storage.dart';
import 'package:volleyscore/widgets/match_card.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.propPlayer});
  final VolleyScorePlayer propPlayer;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late VolleyScorePlayer player;

  @override
  void initState() {
    player = widget.propPlayer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PlayerMatchesStorage>(context, listen: false);
    final playerMatches = store.matches
        .where((match) => match.players.contains(player))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(player.name),
        ),
        body: playerMatches.isEmpty
            ? const Center(
                child: Text('Nessuna partita'),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.blueGrey,
                      child: DefaultTextStyle.merge(
                        style: const TextStyle(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Andamento ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: 'winrate',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextSpan(text: ' e '),
                                    TextSpan(
                                      text: 'score',
                                      style: TextStyle(color: Colors.cyan),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                height: 200,
                                child: Builder(builder: (BuildContext context) {
                                  final matchesIter = List<int>.generate(
                                      playerMatches.length, (i) => i + 1);

                                  LineChartBarData winRateData =
                                      LineChartBarData(
                                    isCurved: true,
                                    color: Colors.green,
                                    barWidth: 8,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(show: false),
                                    spots: matchesIter.map((idx) {
                                      return FlSpot(
                                          idx.toDouble(),
                                          ScoreCalculator.calculateWinRate(
                                                  player,
                                                  playerMatches.sublist(0, idx))
                                              .toDouble());
                                    }).toList(),
                                  );

                                  LineChartBarData scoreData = LineChartBarData(
                                    isCurved: true,
                                    color: Colors.cyan,
                                    barWidth: 8,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: false,
                                      color: Colors.pink.withOpacity(0),
                                    ),
                                    spots: matchesIter.map((idx) {
                                      return FlSpot(
                                          idx.toDouble(),
                                          ScoreCalculator.calculateScore(player,
                                                  playerMatches.sublist(0, idx))
                                              .toDouble());
                                    }).toList(),
                                  );

                                  Widget leftTitleWidgets(
                                      double value, TitleMeta meta) {
                                    return Text(value.toInt().toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.left);
                                  }

                                  Widget bottomTitleWidgets(
                                      double value, TitleMeta meta) {
                                    final idx = value.toInt();
                                    if (![
                                      1,
                                      playerMatches.length ~/ 2,
                                      playerMatches.length - 1
                                    ].contains(idx)) {
                                      return Container();
                                    }

                                    final match = playerMatches[idx];
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat('dd/MM/yy')
                                                .format(match.date),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  final titlesData = FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        interval: 2,
                                        getTitlesWidget: bottomTitleWidgets,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        getTitlesWidget: leftTitleWidgets,
                                        showTitles: true,
                                        interval: 20,
                                        reservedSize: 50,
                                      ),
                                    ),
                                  );

                                  return LineChart(
                                    LineChartData(
                                      lineTouchData: LineTouchData(
                                        handleBuiltInTouches: true,
                                        touchTooltipData: LineTouchTooltipData(
                                          fitInsideVertically: true,
                                          fitInsideHorizontally: true,
                                          tooltipBgColor: Colors.white,
                                          tooltipBorder: const BorderSide(
                                            color: Colors.blueGrey,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      gridData: FlGridData(show: false),
                                      titlesData: titlesData,
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        scoreData,
                                        winRateData,
                                      ],
                                      minY: 0,
                                      maxY: 100,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Partite con ${player.name}:',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    ...playerMatches.map(
                      (e) => MatchCard(match: e, isEditable: false),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

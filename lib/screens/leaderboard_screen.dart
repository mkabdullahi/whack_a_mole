import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whack_a_mole/logic/game_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScores = ref.watch(gameProvider).highScores;

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard', style: GoogleFonts.pressStart2p()),
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dirt_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: highScores.isEmpty
            ? Center(
                child: Text(
                  'No scores yet!\nGo whack some moles!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: highScores.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      '${index + 1}.',
                      style: GoogleFonts.pressStart2p(color: Colors.yellow, fontSize: 20),
                    ),
                    title: Text(
                      '${highScores[index]}',
                      style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 20),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
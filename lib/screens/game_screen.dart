import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whack_a_mole/logic/game_provider.dart';
import 'package:whack_a_mole/widgets/mole_widget.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to safely start the game
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameProvider.notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        elevation: 0,
        title: Text(
          'Catch A Mole',
          style: GoogleFonts.pressStart2p(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dirt_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildScoreboard(gameState),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return MoleWidget(
                      moleType: gameState.moleStatus[index],
                      onTap: () => ref.read(gameProvider.notifier).whackMole(index),
                    );
                  },
                ),
              ),
            ),
            if (!gameState.isActive && gameState.timeLeft == 0) _buildGameOverDialog(context, gameState.score),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreboard(GameState gameState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Score: ${gameState.score}', style: GoogleFonts.pressStart2p(fontSize: 18, color: Colors.white)),
          Text('Time: ${gameState.timeLeft}', style: GoogleFonts.pressStart2p(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildGameOverDialog(BuildContext context, int score) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over', style: GoogleFonts.pressStart2p(fontSize: 32, color: Colors.redAccent)),
            const SizedBox(height: 20),
            Text('Final Score: $score', style: GoogleFonts.pressStart2p(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Main Menu', style: GoogleFonts.pressStart2p()),
            )
          ],
        ),
      ),
    );
  }
}
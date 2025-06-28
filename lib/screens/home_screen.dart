import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whack_a_mole/screens/game_screen.dart';
import 'package:whack_a_mole/screens/leaderboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dirt_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Catch A Mole',
                style: GoogleFonts.pressStart2p(
                  fontSize: 32,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              _buildMenuButton(context, 'Start Game', () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              }),
              const SizedBox(height: 20),
              _buildMenuButton(context, 'Leaderboard', () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown[700],
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 2)
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.pressStart2p(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
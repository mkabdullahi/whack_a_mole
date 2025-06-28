import 'package:flutter/material.dart';
import 'package:whack_a_mole/logic/game_provider.dart';

class MoleWidget extends StatelessWidget {
  final MoleType moleType;
  final VoidCallback onTap;

  const MoleWidget({
    super.key,
    required this.moleType,
    required this.onTap,
  });

  String? _getImagePath() {
    switch (moleType) {
      case MoleType.regular:
        return 'assets/images/mole.png';
      case MoleType.king:
        return 'assets/images/king_mole.png';
      case MoleType.bomb:
        return 'assets/images/bomb.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _getImagePath();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The hole background
            Image.asset('assets/images/hole.png', fit: BoxFit.contain),
            
            // The animated mole
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              bottom: moleType != MoleType.none ? 15 : -80, // Animate up/down
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: moleType != MoleType.none ? 1.0 : 0.0,
                child: imagePath != null
                    ? Image.asset(imagePath, height: 80)
                    : const SizedBox(height: 80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
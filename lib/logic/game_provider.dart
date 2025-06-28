import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MoleType { none, regular, king, bomb }

final gameProvider = StateNotifierProvider<GameNotifier, GameState>(
  (ref) => GameNotifier(),
);

class GameState {
  final int score;
  final int timeLeft;
  final bool isActive;
  final List<MoleType> moleStatus;
  final List<int> highScores;

  GameState({
    this.score = 0,
    this.timeLeft = 30,
    this.isActive = false,
    List<MoleType>? moleStatus,
    this.highScores = const [],
  }) : moleStatus = moleStatus ?? List.generate(9, (_) => MoleType.none);
  GameState copyWith({
    int? score,
    int? timeLeft,
    bool? isActive,
    List<MoleType>? moleStatus,
    List<int>? highScores,
  }) {
    return GameState(
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      isActive: isActive ?? this.isActive,
      moleStatus: moleStatus ?? this.moleStatus,
      highScores: highScores ?? this.highScores,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  Timer? _timer;
  Timer? _moleTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

  GameNotifier() : super(GameState()) {
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores =
        prefs.getStringList('highScores')?.map(int.parse).toList() ?? [];
    scores.sort((a, b) => b.compareTo(a)); // Sort in descending order
    state = state.copyWith(highScores: scores);
  }

  Future<void> _saveHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scores = [...state.highScores, state.score];
    scores.sort((a, b) => b.compareTo(a)); // Sort in descending order
    final uniqueScores = scores.toSet().toList(); // Remove duplicates
    await prefs.setStringList(
      'highScores',
      uniqueScores.take(5).map((s) => s.toString()).toList(),
    );
    state = state.copyWith(highScores: uniqueScores.take(5).toList());
  }

  void startGame() {
    state = GameState(highScores: state.highScores, isActive: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        stopGame();
      }
    });
    _moleTimer = Timer.periodic(_getGameSpeed(), (timer) {
      _showRandomMole();
    });
  }

  void stopGame() {
    _timer?.cancel();
    _moleTimer?.cancel();
    _saveHighScores();
    state = state.copyWith(
      isActive: false,
      moleStatus: List.generate(9, (_) => MoleType.none),
    );
  }

  void whackMole(int index) {
    if (!state.isActive || state.moleStatus[index] == MoleType.none) return;
    int currentScore = state.score;
    MoleType moleType = state.moleStatus[index];

    switch (moleType) {
      case MoleType.regular:
        currentScore += 10;
        _audioPlayer.play(AssetSource('sounds/whack.mp3'));
        break;
      case MoleType.king:
        currentScore += 20;
        _audioPlayer.play(AssetSource('sounds/king_whack.mp3'));
        break;
      case MoleType.bomb:
        currentScore -= 15;
        _audioPlayer.play(AssetSource('sounds/bomb.mp3'));
        break;
      case MoleType.none:
        return; // No action for none
    }
    HapticFeedback.mediumImpact();
    final newMoleStatus = List<MoleType>.from(state.moleStatus);
    newMoleStatus[index] = MoleType.none; // Hide the mole after whacking
    state = state.copyWith(score: currentScore, moleStatus: newMoleStatus);
    _moleTimer?.cancel(); // Stop showing moles after whack
    _moleTimer = Timer.periodic(_getGameSpeed(), (timer) => _showRandomMole());
  }

  void _showRandomMole() {
    final newMoleStatus = List<MoleType>.from(state.moleStatus);
    int currentVisible = newMoleStatus
        .where((mole) => mole != MoleType.none)
        .length;

    if (currentVisible < 3) {
      int toHide = newMoleStatus.indexWhere((mole) => mole != MoleType.none);
      if (toHide != -1) {
        newMoleStatus[toHide] = MoleType.none; // Hide a mole
      }
    }
    int index = _random.nextInt(9);
    if (newMoleStatus[index] == MoleType.none) {
      newMoleStatus[index] = _getRandomMoleType();
      state = state.copyWith(moleStatus: newMoleStatus);
    }
    Future.delayed(_getMoleVisibleDuration(), () {
      if (mounted && state.moleStatus[index] != MoleType.none) {
        final hidingMoleStatus = List<MoleType>.from(state.moleStatus);
        hidingMoleStatus[index] = MoleType.none; // Hide the mole after duration
        state = state.copyWith(moleStatus: hidingMoleStatus);
      }
    });
  }

  MoleType _getRandomMoleType() {
    int roll = Random().nextInt(100);
    if (roll < 10) return MoleType.bomb; // 10% chance for bomb
    if (roll < 20) return MoleType.king; // 10% chance for king mole
    return MoleType.regular; // 80% chance for regular mole{
  }

  Duration _getGameSpeed() {
    int speed = 800 - (state.score * 2);
    return Duration(microseconds: max(350, speed)); // Default speed
  }

  Duration _getMoleVisibleDuration() {
    int duration = 900 - (state.score);
    return Duration(
      microseconds: max(500, duration),
    ); // Duration for which the mole is visible
  }

  @override
  void dispose() {
    _timer?.cancel();
    _moleTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

// This code defines a game provider for a "Whack a Mole" game using Flutter and Riverpod.

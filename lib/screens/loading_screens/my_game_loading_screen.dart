import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/hurdle/game.dart';
import 'package:audioplayers/audioplayers.dart';

import 'loading_screen.dart';
import '/screens/hurdle/bruin.dart';
import '../hurdle/cloud.dart';
import '../hurdle/constants.dart';
import '../hurdle/game_object.dart';
import '../hurdle/ground.dart';
import '../hurdle/hurdle.dart';

class GameLoadingScreen extends StatefulWidget {
  const GameLoadingScreen({Key? key}) : super(key: key);

  @override
  GameLoadingScreenState createState() => GameLoadingScreenState();
}

class GameLoadingScreenState extends State<GameLoadingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssets();
    });
  }

  void _loadAssets() async {
    // Load game assets here
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: _isLoading
          ? const LoadingScreen()
          : const MyGame(),
    );
  }
}

// Future<void> _loadAssets() async {
//
//   List<Hurdle> hurdle = [Hurdle(worldLocation: const Offset(200, 0))];
//
//   List<Ground> ground = [
//     Ground(worldLocation: const Offset(0, 0)),
//     Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
//   ];
//
//   List<Cloud> clouds = [
//     Cloud(worldLocation: const Offset(100, 20)),
//     Cloud(worldLocation: const Offset(200, 10)),
//     Cloud(worldLocation: const Offset(350, -10)),
//   ];
//
//   // Load hurdle sprite
//   // await HurdleSprite.loadSprite();
//   //
//   // // Load ground sprite
//   // await GroundSprite.loadSprite();
//   //
//   // // Load cloud sprite
//   // await CloudSprite.loadSprite();
//
//   // Load other game elements
//   hurdle = [
//     Hurdle(worldLocation: const Offset(200, 0)),
//     Hurdle(worldLocation: const Offset(300, 0)),
//     Hurdle(worldLocation: const Offset(450, 0)),
//   ];
//
//   ground = [
//     Ground(worldLocation: const Offset(0, 0)),
//     Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
//   ];
//
//   clouds = [
//     Cloud(worldLocation: const Offset(100, 20)),
//     Cloud(worldLocation: const Offset(200, 10)),
//     Cloud(worldLocation: const Offset(350, -15)),
//     Cloud(worldLocation: const Offset(500, 10)),
//     Cloud(worldLocation: const Offset(550, -10)),
//   ];
// }

